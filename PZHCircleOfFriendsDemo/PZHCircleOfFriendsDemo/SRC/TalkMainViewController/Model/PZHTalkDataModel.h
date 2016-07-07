//
//  PZHTalkDataModel.h
//  PZHCircleOfFriendsDemo
//
//  Created by nuomi on 16/7/7.
//  Copyright © 2016年 nuomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PZHListItemModel,TalkLikeWebPoModel,TalkCommentModel;
@interface PZHTalkDataModel : NSObject

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<PZHListItemModel *> *list;

@end
@interface PZHListItemModel : NSObject

@property (nonatomic, copy) NSString *talkId;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, copy) NSString *splitText;

@property (nonatomic, strong) TalkLikeWebPoModel *talkLikeWebPo;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, copy) NSString *contentType;

@property (nonatomic, copy) NSString *userimageid;

@property (nonatomic, copy) NSString *contentName;

@property (nonatomic, copy) NSString *contentId;

@property (nonatomic, copy) NSString *contentText;

@property (nonatomic, copy) NSString *atuserids;

@property (nonatomic, copy) NSString *displaytime;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *imageids;

@property (nonatomic, copy) NSString *commentnum;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, strong) NSArray <TalkCommentModel *>*commentPoList;

@property (nonatomic, strong) NSArray *atUserList;

@end

@interface TalkLikeWebPoModel : NSObject

@property (nonatomic, copy) NSString *isLike;

@property (nonatomic, strong) NSArray *userList;

@property (nonatomic, copy) NSString *likenum;

@end

@interface TalkCommentModel : NSObject

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *targetusername;

@property (nonatomic, copy) NSString *targetuserid;

@property (nonatomic, copy) NSString *displaytime;

@property (nonatomic, copy) NSString *userimageid;

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, copy) NSString *targetUserImageid;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *talkid;

@property (nonatomic, copy) NSString *username;
@end




