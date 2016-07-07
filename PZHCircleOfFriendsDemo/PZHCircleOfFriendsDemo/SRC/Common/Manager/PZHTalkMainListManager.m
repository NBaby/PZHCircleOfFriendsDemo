//
//  MCTalkMainListManager.m
//  eCook
//
//  Created by apple on 15/12/16.
//
//

#import "PZHTalkMainListManager.h"
@interface PZHTalkMainListManager (){
    NSDateFormatter * dateFormatter;
}
@end
@implementation PZHTalkMainListManager
+ (instancetype)getInstacne{
    static PZHTalkMainListManager * shareManeger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareManeger == nil) {
              shareManeger = [[PZHTalkMainListManager alloc]init];
        }
    });
    return shareManeger;
}
+ (NSString *)timeTransforme1:(NSString *)time{
    if (time.length <19) {
        return @"";
    }
    NSString * timeStr = [time substringToIndex:19];
    NSDateFormatter * dateFormatter =  [[PZHTalkMainListManager getInstacne] getNSDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [dateFormatter dateFromString:timeStr];
     [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *str= [dateFormatter stringFromDate:inputDate];
    return str;
}

+ (NSString *)getTimeDescriptionWithTime:(NSString *)time{
    if (time.length <19) {
        return @"";
    }
    NSString * timeStr = [time substringToIndex:19];
    NSDateFormatter * dateFormatter =  [[PZHTalkMainListManager getInstacne] getNSDateFormatter];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSDate* inputDate = [dateFormatter dateFromString:timeStr];
    
    NSTimeInterval  timeInterval = [inputDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSString *result;
    long temp = 0;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}
+ (NSArray *)getArrayWithImageStr:(NSString *)string{
    NSCharacterSet *characterSet1 = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSArray *array = [string componentsSeparatedByCharactersInSet:characterSet1];
    return array;
}
+ (NSString *)timeTransforme2:(NSString *)time{
    if (time.length <19) {
        return @"";
    }
    NSString * timeStr = [time substringToIndex:19];
    NSDateFormatter * dateFormatter =  [[PZHTalkMainListManager getInstacne] getNSDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [dateFormatter dateFromString:timeStr];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *str= [dateFormatter stringFromDate:inputDate];
    return str;
}
- (NSDateFormatter *)getNSDateFormatter{
    if (dateFormatter == nil) {
        dateFormatter =  [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}
///将2015-12-07 12:07:09.0转化为 07
+ (NSString *)timeTransforme3:(NSString *)time{
    if (time.length <19) {
        return @"";
    }
    NSString * dateStr = [time substringWithRange:NSMakeRange(8, 2)];
    return dateStr;
}

///将2015-12-07 12:07:09.0转化为 十二
+ (NSString *)timeTransforme4:(NSString *)time{
    if (time.length <19) {
        return @"";
    }
    NSString * monthStr = [time substringWithRange:NSMakeRange(5, 2)];
    if ([monthStr isEqualToString:@"01"]) {
        return  @"一月";
    }
    if ([monthStr isEqualToString:@"02"]) {
        return  @"二月";
    }
    if ([monthStr isEqualToString:@"03"]) {
        return  @"三月";
    }
    if ([monthStr isEqualToString:@"04"]) {
        return  @"四月";
    }
    if ([monthStr isEqualToString:@"05"]) {
        return  @"五月";
    }
    if ([monthStr isEqualToString:@"06"]) {
        return  @"六月";
    }
    if ([monthStr isEqualToString:@"07"]) {
        return  @"七月";
    }
    if ([monthStr isEqualToString:@"08"]) {
        return  @"八月";
    }
    if ([monthStr isEqualToString:@"09"]) {
        return  @"九月";
    }
    if ([monthStr isEqualToString:@"10"]) {
        return  @"十月";
    }
    if ([monthStr isEqualToString:@"11"]) {
        return  @"十一月";
    }
    if ([monthStr isEqualToString:@"12"]) {
        return  @"十二月";
    }
    return @"";
}

@end
