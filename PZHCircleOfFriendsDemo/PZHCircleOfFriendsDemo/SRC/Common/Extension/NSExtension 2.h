//
//  NSArrayExtension.h
//  ticket
//
//  Created by 饺子 on 13-7-18.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

typedef enum {
    ImageColorTypePrimary,
    ImageColorTypeMonochrome,//单色，黑白
    ImageColorTypeBrown,//褐色
    ImageColorTypeInverse,//反色
} ImageColorType;

#import <Foundation/Foundation.h>

@interface NSObject(NSObjectExtension)

- (NSString *)jsonString;



@end

@interface NSArray(NSArrayExtension)

- (id)validObjectAtIndex:(NSUInteger)index;



@end


@interface NSMutableArray(NSMutableArrayExtension)

- (void)removeValuesInArray:(NSArray *)otherArray;



@end


@interface NSDate (NSDateExtension)

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;

- (BOOL)isEarlierThan:(NSDate *)date;
- (BOOL)isEarlier;


- (NSDateComponents *)components;

- (NSInteger)hour;

//2015-05-16 转换为 2015年5月
+ (NSString *)shortDateFormat:(NSString *)date;

//2015-06-10 转换为 星期几
+ (NSInteger)weekDayStr:(NSString *)dateString;

+ (NSString *)getDay:(NSString *)dateString;

@end



@interface NSDateComponents(Calendar)


- (NSString *)dateDescription;
- (NSString *)dateKey;

+ (NSString *)dateKeyWithDescription:(NSString *)description;

+ (NSString *)simpleDescriptionOfWeekday:(NSInteger)weekday;
+ (NSString *)descriptionOfWeekday:(NSInteger)weekday;
+ (NSString *)descriptionOfMonth:(NSInteger)month;

+ (NSInteger)currentYear;
+ (NSInteger)currentMonth;
+ (NSInteger)currentDay;


+ (BOOL)isLeapYear:(NSInteger)year;
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month;
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year;


- (BOOL)isEarlier:(NSDateComponents *)date;
- (BOOL)isLater:(NSDateComponents *)date;
- (BOOL)isEqualTo:(NSDateComponents *)date;


@end


@interface NSDictionary (NSDictionaryExtension)

- (id)validObjectForKey:(id)key;

@end



@interface NSString (NSStringExtension)

+ (BOOL)isEmpty:(NSString *)string;


+ (NSString *)stringWithInt:(int)intValue;
+ (NSString *)stringWithInteger:(NSInteger)integerValue;

- (BOOL)isInt;
- (BOOL)canBePrice;
- (BOOL)canBeNickname;
- (BOOL)canBeEmail;
- (BOOL)canBePhoneNumber;

- (BOOL)contains:(NSString *)aString;

- (NSArray *)getUrls;
- (NSString *)getTitleAsUrl;
- (NSString *)getIDAsUrlWithPrefix:(NSString *)prefix;
- (NSString *)hashString;

- (NSInteger)decimalismAsHexadecimal;

- (NSArray *)extractBySharp;
- (NSArray *)extractByAt;

- (NSMutableString *)formatBySharp;
- (NSMutableString *)formatByAt;

- (NSString *)md5;

- (NSDate *)date;
- (NSDate *)dateWithFormat:(NSString *)format;

- (CGSize)sizeByFont:(UIFont *)font;

- (CGSize)sizeByFont:(UIFont *)font width:(float)width;

- (NSObject *)jsonObject;

@end


@interface UIImage(UIImageExtension)

- (UIImage *)fixOrientation;

- (UIImage*)blurImageWithImage;

+ (UIImage*)imageGrayscale:(UIImage*)anImage type:(ImageColorType)type;

- (UIImage *)imageMergeWithImage:(UIImage *)image;

- (UIImage *)imageWithWidth:(CGFloat)width;
- (UIImage *)imageWithSize:(CGSize)size;

- (UIImage *)imageCutByRatio:(CGFloat)ratio;

- (CGRect)frameInRect:(CGRect)rect;
- (CGRect)frameByRect:(CGRect)rect;
- (CGRect)frameBySize:(CGSize)size;

+ (UIImage*)imageWithView:(UIView*)view;
+ (UIImage*)imageWithView:(UIView*)view scale:(CGFloat)scale;

+ (UIImage*)blurImageWithView:(UIView*)view;

+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
              cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
               borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;


+ (UIImage *)stretchableImageNamed:(NSString *)name;

@end


@interface UIColor(UIColorExtension)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha;

+ (UIColor *)colorWithHexadecimal:(NSString *)hexadecimal;

@end