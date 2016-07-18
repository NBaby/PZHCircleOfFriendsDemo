//
//  MCCommonManager.m
//  eCook
//
//  Created by apple on 15/12/4.
//
//

#import "MCCommonManager.h"

@implementation MCCommonManager
+ (NSURL *)imageUrlHandleWithImageId:(NSString *)imageId size:(int)size square:(BOOL)square{

    NSString * imageSize = @"";
    int imageWidth = size * 2;
    if (square == YES) {
        //77x77 s1
        if (imageWidth >0 && imageWidth < 77) {
            imageSize = @"!s1";
        }
        //100x100 s2
        else if (imageWidth <=100){
            imageSize = @"!s2";
        }
        //140x140 s3
        else if (imageWidth <=140){
            imageSize = @"!s3";
        }
        //156 x 156 s5
        else if (imageWidth <= 156){
            imageSize = @"!s5";
        }
        //193x193 s4
        else if (imageWidth <= 193){
            imageSize = @"!s4";
        }
        //450 x 450 s6
        else if (imageWidth <= 450){
            imageSize = @"!s6";
        }
        //720 x720 s7
        else if (imageWidth <= 720){
            imageSize = @"!s7";
        }
        NSString * imageUrl = [NSString stringWithFormat:@"%@%@.jpg%@",@"http://pic.ecook.cn/web/",imageId,imageSize];
       
        return [NSURL URLWithString:imageUrl];
    }
    //180 x 180 m5
    if (imageWidth <= 180){
        imageSize = @"!m5";
    }
    //200 x 200 m6
    else if (imageWidth <= 200){
        imageSize = @"!m6";
    }
    //230 x 230 m1
    else if (imageWidth <= 230){
        imageSize = @"!m1";
    }
    //300 x 300 m4
    else if (imageWidth <= 300){
        imageSize = @"!m4";
    }
    //360 x360 m7
    else if (imageWidth <= 360){
        imageSize = @"!m7";
    }
    //450 xn m2
    else if (imageWidth <= 450){
        imageSize = @"!m2";
    }
    //600 x 600 m3
    else if (imageWidth <= 600){
        imageSize = @"!m3";
    }
    NSString * imageUrl = [NSString stringWithFormat:@"%@%@.jpg%@",@"http://pic.ecook.cn/web/",imageId,imageSize];
    
 
    return [NSURL URLWithString:imageUrl];
}
+ (NSString *)getStringWithArray:(NSArray *)strArray{
    NSString * resultStr = @"";
    for (int i=0; i< [strArray count]; i++) {
        if (i!=0) {
            resultStr = [NSString stringWithFormat:@"%@,",resultStr];
        }
        resultStr = [NSString stringWithFormat:@"%@%@",resultStr,strArray[i]];
    }
    return  resultStr;
}
+ (NSArray *)getArrayWithImageStr:(NSString *)string{
    NSCharacterSet *characterSet1 = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSArray *array = [string componentsSeparatedByCharactersInSet:characterSet1];
    return array;
}
@end
