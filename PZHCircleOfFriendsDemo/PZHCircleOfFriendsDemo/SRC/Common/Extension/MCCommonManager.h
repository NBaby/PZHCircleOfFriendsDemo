//
//  MCCommonManager.h
//  eCook
//
//  Created by apple on 15/12/4.
//
//

#import <Foundation/Foundation.h>

@interface MCCommonManager : NSObject
///获取图片地址,尺寸自动x2
+ (NSURL *)imageUrlHandleWithImageId:(NSString *)imageId size:(int)size square:(BOOL)square;
///传进去字符串array用逗号拼接
+ (NSString *)getStringWithArray:(NSArray *)strArray;
///逗号隔开的imageStr转换成array
+ (NSArray *)getArrayWithImageStr:(NSString *)string;
@end
