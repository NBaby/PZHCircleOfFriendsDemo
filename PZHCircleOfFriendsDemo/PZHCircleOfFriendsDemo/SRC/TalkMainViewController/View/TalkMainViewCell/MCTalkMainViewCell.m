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
#import "MessageView.h"
@interface MCTalkMainViewCell ()<TTTAttributedLabelDelegate,UIActionSheetDelegate>{
    ///图片array
    NSMutableArray * pictureArray;
    NSMutableArray * textLabelArray;
    NSArray * imageIdArray;
    ///数据源
    PZHListItemModel * dataModel;
    float picWidth ;
    float picHeight ;
    float space;
    ///缓存评论数据
    NSMutableArray * cacheCommentLabels;
    ///缓存评论用户数据
    NSMutableArray * cacheCommentUserPics;

    
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
        [imageView sd_getImageWithId:picArray[i] andSize:picWidth square:NO placeholderImage:[UIImage imageNamed:@"place_holder_album"]];
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


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

}
#pragma mark - 事件响应
///长按事件
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{

    
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
        [imageview sd_getImageWithId:imageIdArray[i] andSize:screenWidth square:NO];
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser  = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = sender.tag;
    browser.photos = photos;
    if (self.fatherController.type != TalkDetail) {
          browser.showDetail = YES;
    }
  
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
    ///如果点击是评论
    if ([result[@"kind"] isEqualToString:@"comment"]) {
        [self.fatherController cellTapComment:dataModel andCommentModel:result[@"object"]];
    }
    ///如果是话题
    if ([result[@"kind"]isEqualToString:@"topic"]) {
        [self.fatherController tapTopic:result[@"object"]];
    }
    ///如果是点击人物名称
    if ([result[@"kind"] isEqualToString:@"user"]) {
        [self.fatherController goToUserCenterWithId:result[@"object"]];
    }
}
#pragma mark  点击评论
- (IBAction)tapComment:(id)sender {
    [self.fatherController cellTapComment:dataModel andCommentModel:nil];
}
#pragma mark  点赞
- (IBAction)tapFavBtn:(UIButton *)sender {
    [[MessageView getInstance]showMessage:@"点赞"];
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