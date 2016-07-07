//
//  MCtalkAboutMeCell.m
//  eCook
//
//  Created by apple on 15/12/21.
//
//

#import "PZHTalkAboutMeCell.h"
#import "Masonry.h"
//#import "MCTalkAboutMeModel.h"
#import "PZHTalkMainListManager.h"
@interface PZHTalkAboutMeCell()<TTTAttributedLabelDelegate>{
//    MCTalkAboutMeListModel * dataModel;
}
@end
@implementation PZHTalkAboutMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.avatarImgView.layer setMasksToBounds:YES];
//    [self.avatarImgView.layer setCornerRadius:self.avatarImgView.height/2];
    self.contentLabel = [[TTTAttributedLabel alloc]initWithFrame:self.textView.bounds];
    
    [self.textView addSubview:self.contentLabel];
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).offset(0);
        make.right.equalTo(self.textView).offset(0);
        make.top.equalTo(self.textView).offset(0);
        make.bottom.equalTo(self.textView).offset(0);
    }];
    UIFont *SystemFont = [UIFont systemFontOfSize:15];
    self.contentLabel.font = SystemFont;
    
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.preferredMaxLayoutWidth = screenWidth -20;
    self.contentLabel.delegate = self;
    self.contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    self.contentLabel.extendsLinkTouchArea = NO;
    
    [self.originalCommentLabel removeFromSuperview];
    self.originalCommentLabel = [[TTTAttributedLabel alloc]initWithFrame:self.originalCommentView.bounds];
   
    self.originalCommentLabel.font = SystemFont;
    self.originalCommentLabel.numberOfLines = 0;
    self.originalCommentLabel.preferredMaxLayoutWidth = screenWidth - 20 - 60- 10;
  
    [self.originalCommentView addSubview:self.originalCommentLabel];
    [self.originalCommentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originalCommentView).offset(8);
        make.left.equalTo(self.userAvatarImageView.mas_right).offset(10);
        make.right.equalTo(self.originalCommentView).offset(0);
        make.bottom.equalTo(self.originalCommentView).offset(-8).priority(750);
    }];
    self.originalCommentLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    self.originalCommentLabel.delegate = self;
    self.originalCommentLabel.extendsLinkTouchArea = NO;
    
    [self.userNameBtn addTarget:self action:@selector(tapUserInformation) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserInformation)];
    [self.avatarImgView addGestureRecognizer:tapGesture];
    self.avatarImgView.userInteractionEnabled = YES;
    
}
- (void)setInfo:(id)info{
//    dataModel = info;
//    [self.userNameBtn setTitle:dataModel.user_nickname forState:UIControlStateNormal];
//    self.subTitleLabel.text = dataModel.title;
////    [self.avatarImgView sd_getImageWithId:dataModel.user_imageid andSize:40 square:YES placeholderImage:[UIImage imageNamed:@"avatar"]];
//    [self.avatarImgView sd_getUserImageWithId:dataModel.user_imageid andSize:40];
//    
//    self.timeLabel.text = [PZHTalkMainListManager timeTransforme1:dataModel.time] ;
//    
//    [self createContentLabel];
//    [self createOriginalLabel];
//    if (dataModel.target_text.length > 0||dataModel.target_imageid.length>0) {
//        self.originalCommentView.hidden = NO;
//        self.bottomConstraint.constant = 1000;
//    }
//    else{
//        self.originalCommentView.hidden = YES;
//        self.bottomConstraint.constant = 5;
//    }
}
- (void)createContentLabel{
   
//    self.contentLabel.text = dataModel.text;
    
    
}
- (void)createOriginalLabel{
//     [self.userAvatarImageView sd_getImageWithId:dataModel.target_imageid andSize:60 square:YES];
//      self.originalCommentLabel.text =dataModel.target_text;
}
#pragma mark 点击用户头像或者名字
- (void)tapUserInformation{
//    [self.fatherController goToPersionalPageWithModel:dataModel];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents{
    
}
@end
@implementation  UITableView(PZHTalkAboutMeCell)

- (PZHTalkAboutMeCell *)PZHTalkAboutMeCell {
    static NSString *CellIdentifier = @"PZHTalkAboutMeCell";
    PZHTalkAboutMeCell *Cell=(PZHTalkAboutMeCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil==Cell) {
        UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:CellIdentifier];
        Cell = (PZHTalkAboutMeCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    Cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return Cell;
}

@end