//
//  NSArrayExtension.m
//  ticket
//
//  Created by 饺子 on 13-7-18.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

#import "NSExtension.h"

@implementation NSString (eCook)

- (NSString *)changeMarkString {
    
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    
    return string;
}


- (NSString *)highlightString {
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"/ecook" withString:@"</key>"];
    string = [string stringByReplacingOccurrencesOfString:@"ecook" withString:@"<key>"];
    
    return string;
}

- (NSString *)cleanMarkString {
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"/ecook" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"ecook" withString:@""];
    
    return string;
}

- (NSString *)cleanHighlightString {
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"<key>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</key>" withString:@""];
    
    return string;
}



@end
