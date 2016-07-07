//
//  UIImageView+MCWebImageView.h
//  eCook
//
//  Created by 嘿你的益达 on 15/12/7.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView(MCWebImageView)
- (void)sd_getImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square;
- (void)sd_getPlaceholderImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square placeholderImage:(UIImage *)placeholderImage;

/*
 *获取圆形头像（并且设置默认头像）
 */
- (void)sd_getUserImageWithId:(NSString *)imgId andSize:(int)size;

//- (void)sd_getCornerImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square placeholderImage:(UIImage *)placeholderImage;

- (void)sd_getImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square placeholderImage:(UIImage *)holderImage;
///获取默认图带圆角
- (void)sd_getImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square placeholderImage:(UIImage *)holderImage cornerRadius:(int)radius;
///获取带圆角的图片不带默认图
- (void)sd_getImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square cornerRadius:(int)radius;
@end
