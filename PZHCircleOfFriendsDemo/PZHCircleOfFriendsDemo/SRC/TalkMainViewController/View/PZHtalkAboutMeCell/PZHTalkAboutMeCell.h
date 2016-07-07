//
//  MCtalkAboutMeCell.h
//  eCook
//
//  Created by apple on 15/12/21.
//
//

#import <UIKit/UIKit.h>
#import "PZHCommonTableViewCell.h"
#import <TTTAttributedLabel.h>
//#import "PZHTalkMyselfViewController.h"
@interface PZHTalkAboutMeCell : PZHCommonTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIView *originalCommentView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
///回复文字
@property (strong, nonatomic) TTTAttributedLabel * contentLabel;
///原始评论文字
@property (strong, nonatomic) TTTAttributedLabel * originalCommentLabel;
///控制是否显示originalCommentView的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
//@property (weak, nonatomic) MCTalkMyselfViewController * fatherController;

@end
@interface UITableView(PZHTalkAboutMeCell)
- (PZHTalkAboutMeCell*)PZHTalkAboutMeCell;
@end