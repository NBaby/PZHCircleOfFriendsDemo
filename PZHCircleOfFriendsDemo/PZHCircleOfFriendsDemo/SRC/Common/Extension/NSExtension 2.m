//
//  NSArrayExtension.m
//  ticket
//
//  Created by 饺子 on 13-7-18.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

#import "NSExtension.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSObject(NSObjectExtension)

- (NSString *)jsonString
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    
    return nil;
}

@end

@implementation NSArray(NSArrayExtension)

- (id)validObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    
    NSObject *object = [self objectAtIndex:index];
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    
    
    return object;
}

@end

@implementation NSMutableArray(NSMutableArrayExtension)

- (void)removeValuesInArray:(NSArray *)otherArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSObject *object in self) {
        if ([otherArray containsObject:object]) {
            [array addObject:object];
        }
    }
    
    [self removeObjectsInArray:array];
}

@end



@implementation NSDate (NSDateExtension)

- (NSString *)string
{
    return [self stringWithFormat:@"yyyy-MM-dd HH:mm:ss.S"];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (BOOL)isEarlierThan:(NSDate *)date
{
    NSComparisonResult result = [self compare:date];
    if (NSOrderedAscending == result) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEarlier
{
    return [self isEarlierThan:[NSDate date]];
}

- (NSDateComponents *)components
{
    return [[NSCalendar currentCalendar] components:
            NSYearCalendarUnit
            | NSMonthCalendarUnit
            | NSDayCalendarUnit
            | NSWeekdayCalendarUnit
                                           fromDate:self];
}

- (NSInteger)hour
{
    return [[self stringWithFormat:@"HH"] integerValue];
}


+ (NSString *)shortDateFormat:(NSString *)dateString
{
    NSDate *date = [dateString dateWithFormat:@"yyyy-MM-dd"];
    NSDateComponents *components = date.components;
    
    NSString *newDate = [NSString stringWithFormat:@"%zi年%zi月", components.year, components.month];
    return newDate;
}

+ (NSString *)getDay:(NSString *)dateString
{
    NSDate *date = [dateString dateWithFormat:@"yyyy-MM-dd"];
    NSDateComponents *components = date.components;
    
    NSString *newDate;
    if (components.day < 10) {
        newDate = [NSString stringWithFormat:@"0%zi", components.day];
    } else {
        newDate = [NSString stringWithFormat:@"%zi", components.day];
    }


    return newDate;
}

+ (NSInteger)weekDayStr:(NSString *)dateString
{
    NSDate *date = [dateString dateWithFormat:@"yyyy-MM-dd"];
    NSDateComponents *components = date.components;
    NSInteger week = components.weekday;
    return week;
}

@end


@implementation NSDateComponents(Calendar)



- (NSString *)dateDescription
{
    return [NSString stringWithFormat:@"%i年%i月%i日 %@", (int)self.year, (int)self.month, (int)self.day, [NSDateComponents descriptionOfWeekday:self.weekday]];
}

- (NSString *)dateKey
{
    return [NSString stringWithFormat:@"%04d-%02d-%02d", (int)self.year, (int)self.month, (int)self.day];
}


+ (NSString *)dateKeyWithDescription:(NSString *)description
{
    NSArray *array = [description componentsSeparatedByString:@"年"];
    if (array.count >= 2) {
        int year = [array.firstObject intValue];
        
        NSString *string = [array objectAtIndex:1];
        array = [string componentsSeparatedByString:@"月"];
        
        int month = [array.firstObject intValue];
        
        string = [array objectAtIndex:1];
        array = [string componentsSeparatedByString:@"日"];
        
        int day = [array.firstObject intValue];
        
        return [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
    }
    return nil;
}

+ (NSString *)simpleDescriptionOfWeekday:(NSInteger)weekday
{
    NSString *weekDay = nil;
    switch (weekday) {
        case 1:
            weekDay = @"日";
            break;
            
        case 2:
            weekDay = @"一";
            break;
            
        case 3:
            weekDay = @"二";
            break;
            
        case 4:
            weekDay = @"三";
            break;
            
        case 5:
            weekDay = @"四";
            break;
            
        case 6:
            weekDay = @"五";
            break;
            
        case 7:
            weekDay = @"六";
            break;
            
        default:
            break;
    }
    
    return weekDay;
}

+ (NSString *)descriptionOfWeekday:(NSInteger)weekday
{
    NSString *weekDay = nil;
    switch (weekday) {
        case 1:
            weekDay = @"星期日";
            break;
            
        case 2:
            weekDay = @"星期一";
            break;
            
        case 3:
            weekDay = @"星期二";
            break;
            
        case 4:
            weekDay = @"星期三";
            break;
            
        case 5:
            weekDay = @"星期四";
            break;
            
        case 6:
            weekDay = @"星期五";
            break;
            
        case 7:
            weekDay = @"星期六";
            break;
            
        default:
            break;
    }
    
    return weekDay;
}

+ (NSString *)descriptionOfMonth:(NSInteger)month
{
    switch (month) {
        case 1:
            return @"一月";
            break;
            
        case 2:
            return @"二月";
            break;
            
        case 3:
            return @"三月";
            break;
            
        case 4:
            return @"四月";
            break;
            
        case 5:
            return @"五月";
            break;
            
        case 6:
            return @"六月";
            break;
            
        case 7:
            return @"七月";
            break;
            
        case 8:
            return @"八月";
            break;
            
        case 9:
            return @"九月";
            break;
            
        case 10:
            return @"十月";
            break;
            
        case 11:
            return @"十一月";
            break;
            
        case 12:
            return @"十二月";
            break;
            
        default:
            return nil;
            break;
    }
}

+ (NSInteger)currentYear
{
    time_t ct = time(NULL);
    struct tm *dt = localtime(&ct);
    int year = dt->tm_year + 1900;
    return year;
}

+ (NSInteger)currentMonth
{
    time_t ct = time(NULL);
    struct tm *dt = localtime(&ct);
    int month = dt->tm_mon + 1;
    return month;
}

+ (NSInteger)currentDay
{
    time_t ct = time(NULL);
    struct tm *dt = localtime(&ct);
    int day = dt->tm_mday;
    return day;
}

+ (BOOL)isLeapYear:(NSInteger)year
{
    NSAssert(!(year < 1), @"invalid year number");
    BOOL leap = FALSE;
    if ((0 == (year % 400))) {
        leap = TRUE;
    }
    else if((0 == (year%4)) && (0 != (year % 100))) {
        leap = TRUE;
    }
    return leap;
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month
{
    return [NSDateComponents numberOfDaysInMonth:month year:[NSDateComponents currentYear]];
}





+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year
{
    NSAssert(!(month < 1||month > 12), @"invalid month number");
    NSAssert(!(year < 1), @"invalid year number");
    month = month - 1;
    static int daysOfMonth[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    NSInteger days = daysOfMonth[month];
    
    if (month == 1) {
        if ([NSDateComponents isLeapYear:year]) {
            days = 29;
        }
        else {
            days = 28;
        }
    }
    return days;
}


- (BOOL)isEarlier:(NSDateComponents *)date
{
    NSDate *thisDate = [[NSCalendar currentCalendar] dateFromComponents:self];
    NSDate *otherDate = [[NSCalendar currentCalendar] dateFromComponents:date];
    
    NSComparisonResult result = [thisDate compare:otherDate];
    
    if (NSOrderedAscending == result) {//已过期
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isLater:(NSDateComponents *)date
{
    NSDate *thisDate = [[NSCalendar currentCalendar] dateFromComponents:self];
    NSDate *otherDate = [[NSCalendar currentCalendar] dateFromComponents:date];
    
    NSComparisonResult result = [thisDate compare:otherDate];
    
    if (NSOrderedDescending == result) {//已过期
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEqualTo:(NSDateComponents *)date
{
    if (self.year == date.year && self.month == date.month && self.day == date.day) {
        return YES;
    }
    
    return NO;
}

@end


@implementation NSDictionary (NSDictionaryExtension)

- (id)validObjectForKey:(id)key
{
    if (key == nil) {
        return nil;
    }
    
    if (![self isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    if (self.count == 0) {
        return nil;
    }
    
    NSObject *object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return object;
}

@end


@implementation NSString (NSStringExtension)

+ (BOOL)isEmpty:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (string.length == 0) {
        return YES;
    }
    
    
    return NO;
}

+ (NSString *)stringWithInt:(int)intValue
{
    return [NSString stringWithFormat:@"%i", intValue];
}

+ (NSString *)stringWithInteger:(NSInteger)integerValue
{
    return [NSString stringWithInt:(int)integerValue];
}

- (BOOL)isInt
{
    if ([NSString isEmpty:self]) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)canBePrice
{
    NSString *Regex = @"^([0-9]*)+(.[0-9]{1,2})?$";
    NSPredicate *nickTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [nickTest evaluateWithObject:self];
}

- (BOOL)canBeNickname
{
    NSString *Regex = @"^[\u4e00-\u9fa5A-Za-z0-9-_]*$";
    NSPredicate *nickTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [nickTest evaluateWithObject:self];
}

- (BOOL)canBeEmail
{
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)canBePhoneNumber{
    NSString *Regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)contains:(NSString *)aString
{
    NSRange range = [self rangeOfString:aString];
    if (range.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

- (NSArray *)getUrls
{
    NSString *content = self;
    if (content.length == 0) {
        return nil;
    }
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"((http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?)|(ecook://[a-z]+\\?id=[1-9][0-9]*)" options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while (content && content.length != 0) {
        NSRange range = [expression rangeOfFirstMatchInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
        if (range.location != NSNotFound) {
            NSString *match = [content substringWithRange:range];
            if (![array containsObject:match]) {
                [array addObject:match];
            }
            content = [content substringFromIndex:range.location + range.length];
        } else {
            break;
        }
    }
    
    return array;
}

- (NSString *)getTitleAsUrl
{
    NSArray *array = [self componentsSeparatedByString:@"/"];
    return array.lastObject;
}

- (NSString *)getIDAsUrlWithPrefix:(NSString *)prefix
{
    if ([self hasPrefix:prefix]) {
        NSString *uid = [self stringByReplacingOccurrencesOfString:prefix withString:@""];
        if (uid.isInt) {
            return uid;
        }
    }
    
    return nil;
}

- (NSString *)hashString
{
    return [NSString stringWithFormat:@"hash_%i", (int)self.hash];
}

- (NSInteger)decimalismAsHexadecimal
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner scanHexInt:&outVal];
    return outVal;
}

- (NSArray *)extractBySharp
{
    NSString *content = self;
    
    NSMutableArray *stringArray = [NSMutableArray array];
    
    NSRange range;
    while (content) {
        range = [content rangeOfString:@"#"];
        NSUInteger location1 = range.location;
        if (location1 == NSNotFound || location1 >= content.length - 2) {//未找到 第一个 #
            break;
        } else {//找到 第一个 #
            range = [[content substringFromIndex:location1 + 2] rangeOfString:@"#"];
            NSUInteger location2 = range.location + location1 + 2;
            if (location2 == NSNotFound || location2 >= content.length) {//未找到第二个#
                break;
            } else {//找到第二个#
                NSString *secondString = [[content substringToIndex:location2 + 1] substringFromIndex:location1];
                [stringArray addObject:secondString];
                
                content = [content substringFromIndex:location2 + 1];
            }
        }
    }
    
    return stringArray;
}

- (NSArray *)extractByAt
{
    NSString *content = self;
    
    NSMutableArray *stringArray = [NSMutableArray array];
    
    NSRange range;
    while (content) {
        range = [content rangeOfString:@"@"];
        NSUInteger location1 = range.location;
        if (location1 == NSNotFound || location1 >= content.length - 2) {//未找到 第一个 @, 或第一个@在尾端
            
            break;
        } else {//找到 第一个 @
            range = [[content substringFromIndex:location1 + 2] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
            NSUInteger location2 = range.location + location1 + 2;
            if (location2 == NSNotFound || location2 >= content.length) {//未找到 :
                
                break;
            } else {//找到 :
                
                NSString *secondString = [[content substringToIndex:location2] substringFromIndex:location1];
                [stringArray addObject:secondString];
                
                content = [content substringFromIndex:location2];
            }
        }
    }
    
    return stringArray;
}


- (NSMutableString *)formatBySharp
{
    NSMutableString *markedString = [NSMutableString stringWithString:self];
    NSRange firstRange = [markedString rangeOfString:@"#"];
    
    while (firstRange.location != NSNotFound && firstRange.location + 2 < markedString.length) {
        
        NSRange secondRange = [markedString rangeOfString:@"#"
                                                  options:NSCaseInsensitiveSearch
                                                    range:NSMakeRange(firstRange.location + 2, markedString.length - firstRange.location - 2)];
        
        if (secondRange.location != NSNotFound) {
            
            [markedString insertString:@"<topic>" atIndex:firstRange.location];
            [markedString insertString:@"</topic>" atIndex:secondRange.location + 8];
            
            NSRange range = NSMakeRange(secondRange.location + 16, markedString.length - secondRange.location - 16);
            
            firstRange = [markedString rangeOfString:@"#"
                                             options:NSCaseInsensitiveSearch
                                               range:range];
        } else {
            break;
        }
    }
    
    return markedString;
}

- (NSMutableString *)formatByAt
{
    NSMutableString *markedString = [NSMutableString stringWithString:self];
    
    NSRange firstRange = [markedString rangeOfString:@"@"];
    
    while (firstRange.location != NSNotFound && firstRange.location + 2 <= markedString.length) {
        
        NSRange secondRange = [markedString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@": "]
                                                            options:NSCaseInsensitiveSearch
                                                              range:NSMakeRange(firstRange.location + 2, markedString.length - firstRange.location - 2)];
        
        if (secondRange.location != NSNotFound) {
            [markedString insertString:@"<at>" atIndex:firstRange.location];
            [markedString insertString:@"</at>" atIndex:secondRange.location + 4];
            
            NSRange range = NSMakeRange(secondRange.location + 10, markedString.length - secondRange.location - 10);
            
            firstRange = [markedString rangeOfString:@"@"
                                             options:NSCaseInsensitiveSearch
                                               range:range];
        } else {
            break;
        }
    }
    
    return markedString;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSDate *)date
{
    return [self dateWithFormat:@"yyyy-MM-dd HH:mm:ss.S"];
}

- (NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}

- (CGSize)sizeByFont:(UIFont *)font
{
    if (font == nil) {
        return CGSizeZero;
    }
    
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size;
}

- (CGSize)sizeByFont:(UIFont *)font width:(float)width {
    if (font == nil) {
        return CGSizeZero;
    }
    
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size;
}

- (NSObject *)jsonObject {
    
    NSData *data = [self dataUsingEncoding:NSStringEncodingConversionAllowLossy];
    
    NSError *error;
    NSObject *object = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
    if (object == nil) {
        return nil;
    }
    return object;
}

@end


@implementation UIImage(UIImageExtension)



#pragma mark - image


//图片旋转90度
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



- (UIImage *)imageMergeWithImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(self.size);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


//图片毛玻璃效果
- (UIImage*)blurImageWithImage{
    NSData *data = UIImageJPEGRepresentation(self, 0.9);
    
    CIImage *ciimage = [CIImage imageWithData:data];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciimage forKey:kCIInputImageKey];
    [filter setValue:@5.0f forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return blurImage;
}


//改变图片色值

+ (UIImage*)imageGrayscale:(UIImage*)anImage type:(ImageColorType)type
{
    CGImageRef  imageRef;
    imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // ピクセルを構成するRGB各要素が何ビットで構成されている
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    // ピクセル全体は何ビットで構成されているか
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    // 画像の横1ライン分のデータが、何バイトで構成されているか
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    // 画像の色空間
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    // 画像のBitmap情報
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // 画像がピクセル間の補完をしているか
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    // 表示装置によって補正をしているか
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    // 画像のデータプロバイダを取得する
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダから画像のbitmap生データ取得
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    // 1ピクセルずつ画像を処理
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4; // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
            
            // RGB値を取得
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            
            switch (type) {
                case ImageColorTypeMonochrome://モノクロ
                    // 輝度計算
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                    
                case ImageColorTypeBrown://セピア
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                    
                case ImageColorTypeInverse://色反転
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                    
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
            
        }
    }
    
    // 効果を与えたデータ生成
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}




//指定宽度等比例缩放图片
- (UIImage *)imageWithWidth:(CGFloat)width
{
    if (width == self.size.width) {
        return self;
    }
    
    CGFloat scaledWidth = width;
    CGFloat scaledHeight = (width * self.size.height) / self.size.width;
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    [self drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage*scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//指定尺寸缩放图片
- (UIImage *)imageWithSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, self.size)) {
        return self;
    }
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//按宽高比进行切割
- (UIImage *)imageCutByRatio:(CGFloat)ratio
{
    float x, y, width, height;
    if (ratio > self.size.width / self.size.height) {//以width为准
        x = 0;
        y = (self.size.height - self.size.width / ratio) / 2;
        width = self.size.width;
        height = self.size.width / ratio;
    } else if (ratio < self.size.width / self.size.height) {
        x = (self.size.width - self.size.height * ratio) / 2;
        y = 0;
        width = self.size.height * ratio;
        height = self.size.height;
    } else {
        return self;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(-x, -y, self.size.width, self.size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)imageCutIntopByRatio:(CGFloat)ratio
{
    float x, y, width, height;
    if (ratio > self.size.width / self.size.height) {//以width为准
        x = 0;
        y = 0;
        width = self.size.width;
        height = self.size.width / ratio;
    } else if (ratio < self.size.width / self.size.height) {
        x = (self.size.width - self.size.height * ratio) / 2;
        y = 0;
        width = self.size.height * ratio;
        height = self.size.height;
    } else {
        return self;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(-x, -y, self.size.width, self.size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark - frame
//frame内图片最大frame，内容不铺满
- (CGRect)frameInRect:(CGRect)rect
{
    CGRect imageFrame;
    
    float widthForMaxHeight = self.size.width * rect.size.height / self.size.height;
    if (widthForMaxHeight < rect.size.width) {//取最大高度
        imageFrame = CGRectMake(rect.origin.x + (rect.size.width - widthForMaxHeight) / 2, rect.origin.y, widthForMaxHeight, rect.size.height);
    } else {
        float heightForMaxWidth = self.size.height * rect.size.width / self.size.width;
        imageFrame = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - heightForMaxWidth) / 2, rect.size.width, heightForMaxWidth);
    }
    
    return imageFrame;
}

//居中图片的frame，内容铺满
- (CGRect)frameByRect:(CGRect)rect
{
    CGRect imageFrame;
    
    float height = self.size.height * rect.size.width / self.size.width;
    if (height > rect.size.height) {//取最大高度
        
        imageFrame = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - height) / 2, rect.size.width, height);
    } else {
        float width = self.size.width * rect.size.height / self.size.height;
        imageFrame = CGRectMake(rect.origin.x + (rect.size.width - width) / 2, rect.origin.y, width, rect.size.height);
    }
    
    return imageFrame;
}

- (CGRect)frameBySize:(CGSize)size
{
    return [self frameByRect:CGRectMake(0, 0, size.width, size.height)];
}

#pragma mark - image
+ (UIImage *)imageWithView:(UIView*)view scale:(CGFloat)scale
{
    UIImage *image = [UIImage imageWithView:view];
    return [image imageWithSize:CGSizeMake(image.size.width * scale, image.size.height * scale)];
}

+ (UIImage *)imageWithView:(UIView *)view
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:currnetContext];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)blurImageWithView:(UIView*)view
{
    NSData *data = UIImageJPEGRepresentation([UIImage imageWithView:view scale:0.99999], 0.3);
    
    CIImage *ciimage = [CIImage imageWithData:data];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciimage forKey:kCIInputImageKey];
    [filter setValue:@5.0f forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:view.frame];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return blurImage;
}

+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (cornerRadius != 0) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = cornerRadius;
    }
    
    if (borderWidth != 0) {
        view.layer.borderWidth = borderWidth;
        if (borderColor) {
            view.layer.borderColor = borderColor.CGColor;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
              cornerRadius:(CGFloat)cornerRadius
{
    return [UIImage imageWithSize:size color:color cornerRadius:cornerRadius borderWidth:0 borderColor:nil];
}

+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
               borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    return [UIImage imageWithSize:size color:color cornerRadius:0 borderWidth:borderWidth borderColor:borderColor];
}

+ (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithSize:CGSizeMake(5, 5) color:color];
}

+ (UIImage *)stretchableImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
}

@end


@implementation UIColor(UIColorExtension)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexadecimal:(NSString *)hexadecimal
{
    if (hexadecimal.length < 6) {
        return nil;
    }
    hexadecimal = [hexadecimal stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (hexadecimal.length != 6) {
        return nil;
    }
    
    NSInteger red = [[hexadecimal substringToIndex:2] decimalismAsHexadecimal];
    NSInteger green = [[hexadecimal substringWithRange:NSMakeRange(2, 2)] decimalismAsHexadecimal];
    NSInteger blue = [[hexadecimal substringFromIndex:4] decimalismAsHexadecimal];
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

@end