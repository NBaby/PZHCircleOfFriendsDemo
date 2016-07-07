//
//  MCTalkMainViewCell.m
//  eCook
//
//  Created by apple on 15/12/11.
//
//

#import "MCTalkMainViewCell.h"
#import <TTTAttributedLabel.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "PZHTalkDataModel.h"
#import "PZHTalkMainListManager.h"
@interface MCTalkMainViewCell ()<TTTAttributedLabelDelegate,UIActionSheetDelegate>{
    ///图片array
    NSMutableArray * pictureArray;
    NSMutableArray * textLabelArray;
    NSArray * imageIdArray;
//    MCTalkListDataModel * dataModel ;
    float picWidth ;
    float picHeight ;
//    __weak TalkCommentModel * currentSeleteModel;
    float space;
    ///缓存相关
    ///缓存评论数据
    NSMutableArray * cacheCommentLabels;
    ///缓存评论用户数据
    NSMutableArray * cacheCommentUserPics;
    PZHListItemModel * dataModel;
    
}
@end
@implementation MCTalkMainViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.favBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    if(screenWidth>350){
        space = 68;
    }
    else {
        space = 50;
    }
    self.contentLabel.extendsLinkTouchArea = NO;
    self.stateLabel.extendsLinkTouchArea = NO;
//    [self.avatarImageView setCornerRadius:self.avatarImageView.height/2];
//    [self.avatarImageView.layer setMasksToBounds:YES];
    //构造contentLabel，厨说主文字界面
    [self createContentView];
    imageIdArray = [[NSArray alloc]init];
    textLabelArray =  [[NSMutableArray alloc]init];
    pictureArray = [[NSMutableArray alloc]init];
    _line = [[UIView alloc]init];
    _line.frame = CGRectMake(0, 0, screenWidth, 0.5);
    _line.backgroundColor = ColorNewLine;
    [self.contentView addSubview:_line];
    [_line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.avatarImageView.opaque = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.stateLabelView.backgroundColor = [UIColor whiteColor];
}
 //构造contentLabel，厨说主文字界面
- (void)createContentView{
    self.contentLabel = [[TTTAttributedLabel alloc]initWithFrame:self.contentLabelView.bounds];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.preferredMaxLayoutWidth = screenWidth - 68-20;
    [self.contentLabelView addSubview:self.contentLabel];
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabelView).offset(0);
        make.right.equalTo(self.contentLabelView).offset(0);
        make.top.equalTo(self.contentLabelView).offset(0);
        make.height.equalTo(self.contentLabelView).offset(0);
    }];
    self.contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    self.contentLabel.delegate = self;
    self.contentLabel.textColor = ColorNewTextBlack;
    
    self.stateLabel = [[TTTAttributedLabel alloc]initWithFrame:self.stateLabelView.bounds];
    [self.stateLabelView addSubview:self.stateLabel];
    UIFont *SystemFont = [UIFont systemFontOfSize:13];
    self.stateLabel.font = SystemFont;
    self.stateLabel.textColor = ColorNewTextGrayDark;
    self.stateLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    self.stateLabel.delegate = self;
    [self.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stateLabelView).offset(5);
        make.top.equalTo(self.stateLabelView).offset(0);
        make.right.equalTo(self.stateLabelView).offset(-5);
        make.bottom.equalTo(self.stateLabelView).offset(0);
    }];

}

- (void)setInfo:(id)info{
    dataModel = info;

    [self.avatarImageView sd_getUserImageWithId:dataModel.userimageid andSize:40];
//    [self.avatarImageView sd_getImageWithId:dataModel.userimageid andSize:40 square:YES];
   
    if ([dataModel.contentType isEqualToString:@"normal"]) {
       self.stateLabel.text = [NSString stringWithFormat:@" %@说 ",[PZHTalkMainListManager getTimeDescriptionWithTime:dataModel.addtime]];
    }
    else {
        NSString * resultStateLabelStr = [NSString stringWithFormat:@"%@%@ %@",[PZHTalkMainListManager getTimeDescriptionWithTime:dataModel.addtime],dataModel.splitText,dataModel.contentText];
        NSRange  range = [resultStateLabelStr rangeOfString:dataModel.contentText];
        [self.stateLabel setText:resultStateLabelStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            UIFont *boldSystemFont = [UIFont systemFontOfSize:13];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:62/255.0 green:81/255.0 blue:105/255.0 alpha:1] CGColor] range:range];
                CFRelease(font);
            }
            return mutableAttributedString;
        }];
        [self.stateLabel addLinkToAddress:@{@"kind":dataModel.contentType ,@"object":dataModel} withRange:range];
    }
    
    self.userNameLabel.text = dataModel.username;
    self.contentLabel.text = dataModel.text;
    [self.favBtn setTitle:dataModel.talkLikeWebPo.likenum forState:UIControlStateNormal];
    if ([dataModel.talkLikeWebPo.isLike isEqualToString:@"1"]){
        self.favBtn.selected = YES;
    }
    else {
        self.favBtn.selected = NO;
    }
    [self.commentBtn setTitle:dataModel.commentnum forState:UIControlStateNormal];
   
    //正则匹配
    [self checkContentLabel];
    imageIdArray = [PZHTalkMainListManager getArrayWithImageStr:dataModel.imageids];
    [self createPicTureView:imageIdArray];

//    [self createCommentView:dataModel.commentPoList];
    
   
  
}

- (void)createPicTureView:(NSArray *)picArray{
    [self.pictureView removeAllSubviews];
    [pictureArray removeAllObjects];
     picWidth = 0;
     picHeight = 0;
    
    int rowPicCount = 1;
    float bigPicViewWidth = screenWidth - space *2;

    if ([picArray count]==0) {
        self.bigPictureViewHeight.constant = 0;
        return ;
    }
    else if ([picArray count] == 1) {
        picWidth = (screenWidth - space *2) ;
        picHeight = picWidth;
        self.bigPictureViewHeight.constant = bigPicViewWidth;
        rowPicCount =1;
    }
    else if ([picArray count] <=2){
        picWidth = (screenWidth - space *2 - 5)/2;
        picHeight = picWidth;
        self.bigPictureViewHeight.constant = picHeight;
        rowPicCount =2;
    }
    else if ([picArray count] <=4){
        picWidth = (screenWidth - space *2 - 5)/2;
        picHeight = picWidth;
        self.bigPictureViewHeight.constant = bigPicViewWidth;
        rowPicCount = 2;
    }
    else if ([picArray count] <=6){
        picWidth = (screenWidth - space *2 - 10)/3;
        picHeight = picWidth;
        self.bigPictureViewHeight.constant = picHeight *2 +5;
        rowPicCount = 3;
    }
    else if ([picArray count] <= 9){
        picWidth = (screenWidth - space *2 - 10)/3;
        picHeight = picWidth;
        self.bigPictureViewHeight.constant = bigPicViewWidth;
        rowPicCount = 3;
    }
    
    float x=0;
    float y =0;
    for (int i =0 ; i<[picArray count]; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y , picWidth, picHeight)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.clipsToBounds = YES;
        imageView.contentMode  =UIViewContentModeScaleAspectFill;
//        [imageView sd_getImageWithId:imageIdArray[i] andSize:picWidth square:NO placeholderImage:[UIImage imageNamed:@"place_holder_album"]];
        [self.pictureView addSubview:imageView];
        [pictureArray addObject:imageView];
        //白色圆角边框
        UIImageView *cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y , picWidth, picHeight)];
        cornerImageView.image = [UIImage stretchableImageNamed:@"white_corner"];
        [self.pictureView addSubview:cornerImageView];

        UIButton * button = [[UIButton alloc]initWithFrame:imageView.frame];
        button.tag = i;
        //点击图片展示
        [button addTarget:self action:@selector(showPic:) forControlEvents:UIControlEventTouchUpInside];
          [self.pictureView addSubview:button];
        if ((i+1)%rowPicCount == 0) {
            x= 0;
            y = y + 5 + picHeight;
        }
        else {
            x= x+picWidth +5;
        }
    }
}

- (void)createCommentView:(NSArray *)dataArray{
    [self.commentView removeAllSubviews];
    [textLabelArray removeAllObjects];
    for (int i = 0; i < [dataArray count]; i++) {
        TalkCommentModel * model = dataArray[i];
        UIImageView * avatar = [[UIImageView alloc]init];

        [self.commentView addSubview:avatar];
       
        

        [avatar sd_getUserImageWithId:model.userimageid andSize:20];
    
        [avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentView).offset(5);
            if (i == 0) {
                 make.top.equalTo(self.commentView).offset(5);
            }
            else {
                make.top.equalTo(((UILabel *)textLabelArray[i-1]).mas_bottom).offset(5);
            }
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
         UIButton * avatarBtn = [[UIButton alloc]init];
        avatarBtn.tag = i;
        [avatarBtn addTarget:self action:@selector(tapAvatar:) forControlEvents:UIControlEventTouchUpInside];
         [self.commentView addSubview:avatarBtn];
        [avatarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentView).offset(5);
            if (i == 0) {
                make.top.equalTo(self.commentView).offset(5);
            }
            else {
                make.top.equalTo(((UILabel *)textLabelArray[i-1]).mas_bottom).offset(5);
            }
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        TTTAttributedLabel * textLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        textLabel.extendsLinkTouchArea = NO;
        textLabel.font = [UIFont systemFontOfSize:13];
        NSString * userName1 = model.username;
        
        NSString * userName2 = model.targetusername;
        NSString * text = model.text;
        NSRange firstRange = NSMakeRange(0, userName1.length);
        NSRange secondRange;
        NSRange thirdRange;
        NSString * result = [NSString stringWithFormat:@"%@",userName1];
        if (userName2.length > 0) {
            result = [NSString stringWithFormat:@"%@ 回复 %@",result,userName2];
            secondRange = NSMakeRange(userName1.length+4, userName2.length);
        }
        else {
            secondRange = NSMakeRange(userName1.length+4, 0);
        }
        result = [NSString stringWithFormat:@"%@ :%@",result,text];
        thirdRange = NSMakeRange(0, result.length);
        textLabel.lineSpacing = 5;
         textLabel.preferredMaxLayoutWidth = screenWidth - 68 -20 -5-5-10;
        textLabel.numberOfLines = 5;
        
        textLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];

        [textLabel setText:result afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
          
            UIFont *boldSystemFont = [UIFont systemFontOfSize:13];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (font) {
                //设置可点击文本的大小
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:firstRange];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:secondRange];
                //设置可点击文本的颜色
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:62/255.0 green:81/255.0 blue:105/255.0 alpha:1] CGColor] range:firstRange];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:62/255.0 green:81/255.0 blue:105/255.0 alpha:1] CGColor] range:secondRange];
                
                CFRelease(font);
            }
            return mutableAttributedString;
        }];
        
        textLabel.delegate = self;
       
       

//        [textLabel addLinkToAddress:@{@"kind":@"comment",@"object":model} withRange:thirdRange];
//        [textLabel addLinkToAddress:@{@"kind":@"user",@"object":model.userid} withRange:firstRange];
//        [textLabel addLinkToAddress:@{@"kind":@"user",@"object":model.targetuserid} withRange:secondRange];
               [self.commentView addSubview:textLabel];
        ///添加长按事件
        textLabel.tag = i;
        UILongPressGestureRecognizer * longPressGestureRecognizer =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        [textLabel addGestureRecognizer:longPressGestureRecognizer];
        [textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(avatar.mas_right).offset(5);
            make.right.equalTo(self.commentView).offset(-10);
            if (i != 0 ) {
                make.top.equalTo(((UILabel *)textLabelArray[i-1]).mas_bottom).offset(8);
            }
            else {
                make.top.equalTo (self.commentView).offset(5);
            }
            if ( i == [dataArray count] -1) {
                make.bottom.equalTo(self.commentView).offset(-5)
                ;
            }
        }];
        
        [textLabelArray addObject:textLabel];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(actionSheet.numberOfButtons ==3){
//        if (buttonIndex == 0) {
//            //举报
//            [[ReportManager getInstance] reportWithTargetID:currentSeleteModel.commentId object:@"comment"];
//        }
//        else if (buttonIndex == 1){
//            //删除
//            WS(wSelf);
//            [HttpRequest deleteCommentWithTalkId:currentSeleteModel.talkid CommentId:currentSeleteModel.commentId andBlock:^(NSDictionary *result, NSError *error) {
//                SS(sSelf);
//                [[MessageView getInstance] stop];
//                if (error == nil){
//                    if ([result[@"state"] isEqualToString:@"200"]) {
//                        [[MessageView getInstance]showMessage:@"删除成功"];
//                        NSMutableArray * tmpMutableArray = [[NSMutableArray alloc]initWithArray: dataModel.commentPoList];
//                        [tmpMutableArray removeObject:currentSeleteModel];
//                        dataModel.commentPoList  = [tmpMutableArray copy];
//                        dataModel.commentnum = [NSString stringWithFormat:@"%d",dataModel.commentnum.intValue -1];
//                        [sSelf.fatherController clearSessionCache:dataModel];
//                        [sSelf.fatherController.mainTableView reloadData];
//                    }
//                    else{
//                        [[MessageView getInstance]showMessage:result[@"message"]];
//                    }
//                    
//                }else{
//                    MSLog(@"%@",error);
//                    [[MessageView getInstance]showMessage:@"与服务器连接出错，请稍后再试"];
//                }
//            }];
//        }
//    }
//    else {
//        if (buttonIndex == 0) {
//            //删除
//            WS(wSelf);
//            [HttpRequest deleteCommentWithTalkId:currentSeleteModel.talkid CommentId:currentSeleteModel.commentId andBlock:^(NSDictionary *result, NSError *error) {
//                SS(sSelf);
//                [[MessageView getInstance] stop];
//                if (error == nil){
//                    if ([result[@"state"] isEqualToString:@"200"]) {
//                        [[MessageView getInstance]showMessage:@"删除成功"];
//                        NSMutableArray * tmpMutableArray = [[NSMutableArray alloc]initWithArray: dataModel.commentPoList];
//                        [tmpMutableArray removeObject:currentSeleteModel];
//                        dataModel.commentPoList  = [tmpMutableArray copy];
//                       [sSelf.fatherController clearSessionCache:dataModel];
//                         dataModel.commentnum = [NSString stringWithFormat:@"%d",dataModel.commentnum.intValue -1];
//                        [sSelf.fatherController.mainTableView reloadData];
//                    }
//                    else{
//                        [[MessageView getInstance]showMessage:result[@"message"]];
//                    }
//                    
//                }else{
//                    MSLog(@"%@",error);
//                    [[MessageView getInstance]showMessage:@"与服务器连接出错，请稍后再试"];
//                }
//            }];
//        }
//    }
}
#pragma mark - 事件响应
///长按事件
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
//     if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        
//         long num = longPressGestureRecognizer.view.tag;
//          currentSeleteModel = dataModel.commentPoList[num];
//         if (![dataModel.userid isEqualToString:[AccountManager UserID]]) {
//             return;
//         }
//         if ([currentSeleteModel.userid isEqualToString:[AccountManager UserID]]) {
//             UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
//             [sheet showInView:self.fatherController.view];
//         }
//         else {
//             UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"删除", nil];
//             [sheet showInView:self.fatherController.view];
//         }
//         
//     }
    
}
//浏览图片
- (void)showPic:(UIButton *)sender{
    [self.fatherController hideKeyBoard];
    long count = [pictureArray count];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcImageView = pictureArray[i]; // 来源于哪个UIImageView
        UIImageView * imageview = [[UIImageView alloc]init];
//        [imageview sd_getImageWithId:imageIdArray[i] andSize:screenWidth square:NO];
//      
//        photo.url = [MCCommonManager imageUrlHandleWithImageId:imageIdArray[i]  size:screenWidth square:NO];
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser  = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = sender.tag;
    browser.photos = photos;
    if (self.fatherController.type != TalkDetail) {
          browser.showDetail = YES;
    }
  
    browser.delegate = self;
    [browser show];
}
#pragma mark - MJPhotoBrowserDelegate
- (void)showDetailPic{
//    [self.fatherController tapDetailBtn:dataModel];
}

///正则匹配
- (void)checkContentLabel{
    NSString *searchText =self.contentLabel.text;
    if (searchText == nil) {
        return;
    }
    NSError *error = NULL;
     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#.[^#]*#" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *result = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];

    [self.contentLabel setText:self.contentLabel.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        UIFont *boldSystemFont = [UIFont systemFontOfSize:17];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            for (int i = 0; i<[result count]; i++) {
                 NSTextCheckingResult * checkResult = result[i];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:checkResult.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:62/255.0 green:81/255.0 blue:105/255.0 alpha:1] CGColor] range:checkResult.range];
            }
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    
    for (int i= 0; i < [result count]; i++) {
         NSTextCheckingResult * checkResult = result[i];
        NSString * tmpStr = [self.contentLabel.text substringWithRange:NSMakeRange(checkResult.range.location+1, checkResult.range.length-2)];
        
        [self.contentLabel addLinkToAddress:@{@"kind":@"topic",@"object":tmpStr} withRange:checkResult.range];
    }
    
}
///文字点击
- (void)attributedLabel:( TTTAttributedLabel *)label
   didSelectLinkWithAddress:(NSDictionary *)result{
//    ///如果点击是评论
//    if ([result[@"kind"] isEqualToString:@"comment"]) {
//        [self.fatherController cellTapComment:dataModel andCommentModel:result[@"object"]];
//    }
//    ///如果是话题
//    if ([result[@"kind"]isEqualToString:@"topic"]) {
//        [self.fatherController tapTopic:result[@"object"]];
//    }
//    ///如果是点击人物名称
//    if ([result[@"kind"] isEqualToString:@"user"]) {
//        [self.fatherController goToUserCenterWithId:result[@"object"]];
//    }
//    if ([result[@"kind"] isEqualToString:dataModel.contentType ]){
//        [self.fatherController tapCollectionOrRecipeWithModel:dataModel];
//    }
}
//点击评论
- (IBAction)tapComment:(id)sender {

//    [self.fatherController cellTapComment:dataModel andCommentModel:nil];
}
//点赞
- (IBAction)tapFavBtn:(UIButton *)sender {
//    [self.fatherController tapFavBtn:!sender.selected dataModel:dataModel];
//    if ([AccountManager AccountType] == AccountTypeNone) {
//        [ViewControllerManager loginWithBlock:^{
//            [self tapFavBtn:sender];
//        }];
//        return;
//    }
//    if (![AccountManager hasMobile]) {
//        [ViewControllerManager connectPhoneInController:self.fatherController Block:^{
//            [self tapFavBtn:sender];
//        }];
//        return;
//    }
//    if (([dataModel.contentType isEqualToString:@"recipe"]||[dataModel.contentType isEqualToString:@"collectionsort"])&&sender.selected) {
//        [[MessageView getInstance]showMessage:@"您已喜欢"];
//        return;
//    }
//
//    sender.selected = !sender.selected;
//    TalkLikeModel * talkLikeModel = dataModel.talkLikeWebPo;
//    int curentNum = [talkLikeModel.likenum intValue];
//    if (sender.selected) {
//        [self.favBtn setTitle:[NSString stringWithFormat:@"%d",curentNum+1] forState:UIControlStateNormal];
//        talkLikeModel.likenum = [NSString stringWithFormat:@"%d",curentNum+1];
//        talkLikeModel.isLike = @"1";
//    }
//    else {
//        if (curentNum > 0) {
//            [self.favBtn setTitle:[NSString stringWithFormat:@"%d",curentNum-1] forState:UIControlStateNormal];
//              talkLikeModel.likenum = [NSString stringWithFormat:@"%d",curentNum-1];
//           
//        }
//         talkLikeModel.isLike = @"0";
//    }
}
///点击主用户头像
- (IBAction)tipUserAvatar:(id)sender {
   [ self.fatherController goToUserCenterWithId:dataModel.userid];
}
- (void)tapAvatar:(UIButton *)btn{
    TalkCommentModel * model =dataModel.commentPoList[btn.tag ];
    [self.fatherController goToUserCenterWithId:model.userid];
}
@end
@implementation  UITableView(MCTalkMainViewCell)

- (MCTalkMainViewCell *)MCTalkMainViewCell {
    static NSString *CellIdentifier = @"MCTalkMainViewCell";
    MCTalkMainViewCell *Cell=(MCTalkMainViewCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil==Cell) {
        UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:CellIdentifier];
        Cell = (MCTalkMainViewCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    Cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return Cell;
}

@end