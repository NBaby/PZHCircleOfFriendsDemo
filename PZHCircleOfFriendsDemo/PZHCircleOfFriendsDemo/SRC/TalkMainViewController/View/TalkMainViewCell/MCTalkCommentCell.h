//
//  MCTalkCommentCell.h
//  eCook
//
//  Created by apple on 16/1/25.
//
//

#import <UIKit/UIKit.h>
#import "PZHCommonTableViewCell.h"
#import "PZHTalkMainViewController.h"
#import "TTTAttributedLabel.h"

@interface MCTalkCommentCell : PZHCommonTableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) PZHTalkMainViewController *fatherController;

@property (strong, nonatomic) TTTAttributedLabel * contentLabel;

@property (strong, nonatomic) UIView * line;

@property (assign, nonatomic) TalkViewControllerType type;
@end
@interface UITableView(MCTalkCommentCell)
- (MCTalkCommentCell *)MCTalkCommentCell;

@end