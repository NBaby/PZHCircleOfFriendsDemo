//
//  MCTalkMainViewController.h
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import <UIKit/UIKit.h>
#import "PZHCommonViewController.h"
//#import "MCPersionalCenterManager.h"
typedef enum{
    TalkTypeNomal,
    TalkTopic,
    TalkDetail
}TalkViewControllerType;
@class PZHListItemModel,TalkCommentModel;
@interface PZHTalkMainViewController : PZHCommonViewController

///评论框
@property (weak, nonatomic) IBOutlet UIView *commentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeight;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (copy, nonatomic) NSString * topicStr;
@property (assign,nonatomic) TalkViewControllerType type;
///detailType
@property (copy,nonatomic) NSString * talkDetailId;
- (void)hideKeyBoard;
///点击评论按钮
- (void)cellTapComment:(PZHListItemModel *)talkListDataModel  andCommentModel:(TalkCommentModel *)talkCommentModel;
///厨说点赞
//- (void)tapFavBtn:(BOOL)state dataModel:(MCTalkListDataModel *)modelData;
///点击话题
- (void)tapTopic:(NSString *)topic;
///进入详情页
//- (void)tapDetailBtn:(MCTalkListDataModel *)modelData;
///进入与我相关
- (void)aboutMyself;
///点击头像,用户名字
//- (void)goToUserCenterWithId:(NSString *)userId;
///清除缓存
//- (void)clearCacheWithModel:(MCTalkListDataModel *)model;
//- (void)clearSessionCache:(MCTalkListDataModel *)model;
///点击了专辑或者菜谱
//- (void)tapCollectionOrRecipeWithModel:(MCTalkListDataModel *)model;
@end
