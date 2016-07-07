//
//  MCTlakLookMoreCell.h
//  eCook
//
//  Created by apple on 16/2/2.
//
//

#import <UIKit/UIKit.h>
#import "PZHCommonTableViewCell.h"
#import "PZHTalkMainViewController.h"
@interface MCTlakLookMoreCell : PZHCommonTableViewCell
@property (weak,nonatomic)PZHTalkMainViewController* fatherViewController;
- (void)setInfo:(id)info;
@end
@interface UITableView(MCTlakLookMoreCell)
- (MCTlakLookMoreCell*)MCTlakLookMoreCell;
@end