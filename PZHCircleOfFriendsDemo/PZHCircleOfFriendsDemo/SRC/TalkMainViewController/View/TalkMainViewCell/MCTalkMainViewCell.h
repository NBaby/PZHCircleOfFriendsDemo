//
//  MCTalkMainViewCell.h
//  eCook
//
//  Created by apple on 15/12/11.
//
//

#import <UIKit/UIKit.h>
#import "PZHCommonTableViewCell.h"
#import <TTTAttributedLabel.h>
#import "PZHTalkMainViewController.h"
@interface MCTalkMainViewCell : PZHCommonTableViewCell
///头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
///用户名称
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
///照片墙
@property (weak, nonatomic) IBOutlet UIView *pictureView;
///评论
@property (weak, nonatomic) IBOutlet UIView *commentView;
///状态label
@property (strong, nonatomic)  TTTAttributedLabel *stateLabel;
///状态labelView
@property (weak, nonatomic) IBOutlet UIView *stateLabelView;

///评论按钮
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
///收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
///厨说内容
@property (weak, nonatomic) IBOutlet UIView *contentLabelView;
///厨说内容label
@property (strong, nonatomic) TTTAttributedLabel * contentLabel;

@property (weak, nonatomic) PZHTalkMainViewController *fatherController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigPictureViewHeight;

@property (strong, nonatomic) UIView * line;

@end
@interface UITableView(MCTalkMainViewCell)
- (MCTalkMainViewCell *)MCTalkMainViewCell;

@end