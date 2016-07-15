//
//  MCTalkCommentCell.m
//  eCook
//
//  Created by apple on 16/1/25.
//
//

#import "MCTalkCommentCell.h"
#import "PZHTalkDataModel.h"
#import "TTTAttributedLabel.h"

@interface MCTalkCommentCell()<TTTAttributedLabelDelegate,UIActionSheetDelegate>{
    TalkCommentModel * dataModel;
    PZHListItemModel * listModel;
    
}
@property (weak, nonatomic) IBOutlet UIView *commentView;
@end

@implementation MCTalkCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = ColorNewLine;
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    
}
- (void)setInfo:(id)info{

    dataModel = [info objectForKey:@"commentModel"];
    listModel = [info objectForKey:@"listModel"];
    [self.commentView removeAllSubviews];
    UIImageView * avatar = [[UIImageView alloc]init];
    [self.commentView addSubview:avatar];
    [avatar sd_getUserImageWithId:dataModel.userimageid andSize:20];
    [avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentView).offset(6);
        make.top.equalTo(self.commentView).offset(3);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.bottom.lessThanOrEqualTo (self.commentView).offset(-3);
       
    }];
    UIButton * avatarBtn = [[UIButton alloc]init];
    [avatarBtn addTarget:self action:@selector(tapAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView addSubview:avatarBtn];
    [avatarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentView).offset(0);
        make.width.mas_equalTo(26);
        make.top.equalTo(self.commentView).offset(0);

        
    }];
    TTTAttributedLabel * textLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    textLabel.extendsLinkTouchArea = NO;
    textLabel.font = FontRealityNormal;
    NSString * userName1 = dataModel.username;
    NSString * userName2 = dataModel.targetusername;
    NSString * text = dataModel.text;
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
    textLabel.preferredMaxLayoutWidth = screenWidth - 68 -30 -6-6-10;
    if (self.type == TalkTypeNomal) {
         textLabel.numberOfLines = 5;
    }
    else {
         textLabel.numberOfLines = 0;
    }
   
    
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
    [textLabel addLinkToAddress:@{@"kind":@"comment",@"object":dataModel} withRange:thirdRange];
    [textLabel addLinkToAddress:@{@"kind":@"user",@"object":dataModel.userid} withRange:firstRange];
    [textLabel addLinkToAddress:@{@"kind":@"user",@"object":dataModel.targetuserid} withRange:secondRange];
    [self.commentView addSubview:textLabel];
    ///添加长按事件
    UILongPressGestureRecognizer * longPressGestureRecognizer =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [textLabel addGestureRecognizer:longPressGestureRecognizer];
    [textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentView).offset(3);
        make.left.equalTo(avatar.mas_right).offset(5);
        make.right.equalTo(self.commentView).offset(-10);
        make.bottom.equalTo(self.commentView).offset(-3);
    }];
}

- (void)tapAvatar:(UIButton *)btn{
//    [self.fatherController goToUserCenterWithId:dataModel.userid];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:( TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)result{
//    //如果点击是评论
//    if ([result[@"kind"] isEqualToString:@"comment"]) {
//        [self.fatherController cellTapComment:listModel andCommentModel:result[@"object"]];
//    }
//    ///如果是点击人物名称
//    if ([result[@"kind"] isEqualToString:@"user"]) {
//        [self.fatherController goToUserCenterWithId:result[@"object"]];
//    }
}
#pragma mark - 事件响应
///长按事件
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
//    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        
//        
//        if (![listModel.userid isEqualToString:[AccountManager UserID]]) {
//            return;
//        }
//        if ([dataModel.userid isEqualToString:[AccountManager UserID]]) {
//            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
//            [sheet showInView:self.fatherController.view];
//        }
//        else {
//            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"删除", nil];
//            [sheet showInView:self.fatherController.view];
//        }
//        
//    }
//    
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.numberOfButtons ==3){
    }
}
@end
@implementation  UITableView(MCTalkMainViewCell)

- (MCTalkCommentCell *)MCTalkCommentCell {
    static NSString *CellIdentifier = @"MCTalkCommentCell";
    MCTalkCommentCell *Cell=(MCTalkCommentCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil==Cell) {
        UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:CellIdentifier];
        Cell = (MCTalkCommentCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    Cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return Cell;
}

@end