//
//  NSArrayExtension.h
//  ticket
//
//  Created by 饺子 on 13-7-18.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

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

//“2015-05-10” 格式的日期是否为今天
+ (BOOL)isTodayDate:(NSString *)dateString;

// 星期 （一，二，三，四，五，六，日）  分别为数字  （2， 3， 4， 5 ， 6， 7， 1）
+ (NSInteger)weekDayStr:(NSString *)dateString;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;

- (BOOL)isEarlierThan:(NSDate *)date;
- (BOOL)isEarlier;


- (NSDateComponents *)components;

- (NSInteger)hour;

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

//ios9 之后第三方控件不支持\r换行
- (NSString *)replaceStringWithBlack;

+ (NSString *)stringWithInt:(int)intValue;
+ (NSString *)stringWithInteger:(NSInteger)integerValue;

- (BOOL)isInt;
- (BOOL)canBePrice;
- (BOOL)canBeNickname;
- (BOOL)canBeEmail;

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

- (NSObject *)jsonObject;

@end


@interface UIImage(UIImageExtension)
- (UIImage *)fixOrientation;
- (UIImage *)imageMergeWithImage:(UIImage *)image;

- (UIImage *)imageWithWidth:(CGFloat)width;
- (UIImage *)imageWithSize:(CGSize)size;

- (UIImage *)imageCutByRatio:(CGFloat)ratio;
- (UIImage *)imageCutIntopByRatio:(CGFloat)ratio;

- (CGRect)frameInRect:(CGRect)rect;
- (CGRect)frameByRect:(CGRect)rect;
- (CGRect)frameBySize:(CGSize)size;

+ (UIImage*)imageWithView:(UIView*)view;
+ (UIImage*)imageWithView:(UIView*)view scale:(CGFloat)scale;

+ (UIImage*)blurImageWithView:(UIView*)view;
+ (UIImage*)blurImageWithImage:(UIImage *)image;

+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
              cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
               borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)imageUploadWithWidth:(CGFloat)width;

+ (UIImage *)stretchableImageNamed:(NSString *)name;

@end


@interface UIColor(UIColorExtension)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha;

+ (UIColor *)colorWithHexadecimal:(NSString *)hexadecimal;

@end