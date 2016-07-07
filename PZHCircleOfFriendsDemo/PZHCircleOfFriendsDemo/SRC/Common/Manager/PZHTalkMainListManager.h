//
//  MCTalkMainListManager.h
//  eCook
//
//  Created by apple on 15/12/16.
//
//

#import <Foundation/Foundation.h>

@interface PZHTalkMainListManager : NSObject

+ (instancetype)getInstacne;
///将2015-12-07 12:07:09.0转化为1分钟前 ，1小时前，1天前 1年前
+ (NSString *)getTimeDescriptionWithTime:(NSString *)time;
///将2015-12-07 12:07:09.0转化为 12月02日 18:48
+ (NSString *)timeTransforme1:(NSString *)time;
///将2015-12-07 12:07:09.0转化为 18:48
+ (NSString *)timeTransforme2:(NSString *)time;
///将2015-12-07 12:07:09.0转化为 07
+ (NSString *)timeTransforme3:(NSString *)time;
///将2015-12-07 12:07:09.0转化为 十二
+ (NSString *)timeTransforme4:(NSString *)time;

///逗号隔开的imageStr转换成array
+ (NSArray *)getArrayWithImageStr:(NSString *)string;
@end
