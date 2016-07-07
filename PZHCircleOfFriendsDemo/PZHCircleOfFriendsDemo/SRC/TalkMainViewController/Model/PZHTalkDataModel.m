//
//  PZHTalkDataModel.m
//  PZHCircleOfFriendsDemo
//
//  Created by nuomi on 16/7/7.
//  Copyright © 2016年 nuomi. All rights reserved.
//

#import "PZHTalkDataModel.h"

@implementation PZHTalkDataModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list" : [PZHListItemModel class]};
}
@end
@implementation PZHListItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"commentPoList" : [TalkCommentModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"talkId":@"id"};
}
@end


@implementation TalkLikeWebPoModel

@end

@implementation TalkCommentModel

@end
