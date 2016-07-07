//
//  UIImageView+MCWebImageView.m
//  eCook
//
//  Created by 嘿你的益达 on 15/12/7.
//
//

#import "UIImageView+MCWebImageView.h"
#import "MCCommonManager.h"
@implementation UIImageView(MCWebImageView)
- (void)sd_getImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square{
    [self sd_setImageWithURL:[MCCommonManager imageUrlHandleWithImageId:imgId size:size square:square] ];
}

- (void)sd_getImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square placeholderImage:(UIImage *)holderImage{
    [self sd_setImageWithURL:[MCCommonManager imageUrlHandleWithImageId:imgId size:size square:square] placeholderImage:holderImage];
}

- (void)sd_getPlaceholderImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square placeholderImage:(UIImage *)placeholderImage {
    NSURL *url = [MCCommonManager imageUrlHandleWithImageId:imgId size:size square:square];
    
    [self sd_setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)sd_getUserImageWithId:(NSString *)imgId andSize:(int)size {
   
     NSURL *url = [MCCommonManager imageUrlHandleWithImageId:imgId size:size square:YES];
    UIImage *userImage = [[UIImage imageNamed:@"avatar"] hanledCornerImage];
    [self sd_setImageWithURL:url placeholderImage:userImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
             self.image = [image hanledCornerImage] ;
        }
       
    }];
}
- (void)sd_getImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square placeholderImage:(UIImage *)holderImage cornerRadius:(int)radius{
     NSURL *url = [MCCommonManager imageUrlHandleWithImageId:imgId size:size square:YES];
    [self sd_setImageWithURL:url placeholderImage:holderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = [image imageWithCornerRadius:radius];
    }];

}
///获取带圆角的图片不带默认图
- (void)sd_getImageWithId:(NSString *)imgId andSize:(int)size square:(BOOL)square cornerRadius:(int)radius{
     NSURL *url = [MCCommonManager imageUrlHandleWithImageId:imgId size:size square:YES];
    [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = [image imageWithCornerRadius:radius];
    }];
}
@end
