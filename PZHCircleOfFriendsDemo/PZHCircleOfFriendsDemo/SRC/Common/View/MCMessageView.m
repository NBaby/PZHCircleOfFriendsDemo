//
//  MessageView.m
//  iCook
//
//  Created by Jehy Fan on 15/8/13.
//  Copyright (c) 2015年 Jehy Fan. All rights reserved.
//

#import "MCMessageView.h"
#import "AppDelegate.h"
static NSTimeInterval const DefaultTimeInterval = 2.0;


@implementation MCMessageView

- (id)init {
    self = [super init];
    
    if(self) {
        
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIWindow* window = appDelegate.window;

        [window addSubview:self];
        
        self.frame = CGRectMake(0, 0, screenWidth , screenHeight);
        
        progressView = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:progressView];
        [self bringSubviewToFront:progressView];
        
        progressView.delegate = self;
        
        
    }
    return self;
}

+ (MCMessageView *)getInstance {
    static MCMessageView *instante = nil;
    if (instante == nil) {
        instante = [[MCMessageView alloc] init];
    }
    
    return instante;
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
    self.alpha = 0;
}

- (void)hide
{
    [progressView hide:NO];
}

- (void)showText:(NSString *)text {
    
    [progressView hide:NO];
    self.alpha = 1;
    
    progressView.minShowTime = 0;
    progressView.labelText = text;
    progressView.mode = MBProgressHUDModeIndeterminate;
    [progressView show:YES];
}

- (void)startDealing {
    [self showText:@"处理中..."];
}

- (void)startLoading {
    [self showText:@"加载中..."];
}

- (void)showMessage:(NSString *)message {
    
    self.alpha = 1;
    [progressView hide:NO];
    progressView.labelText = message;
    progressView.minShowTime = DefaultTimeInterval;
    progressView.mode = MBProgressHUDModeText;
    [progressView showAnimated:YES whileExecutingBlock:^{
        
        
    } completionBlock:^{
        
    }];
}

- (void)showNetworkError {
    [self showMessage:@"网络异常，请稍后重试~"];
}

@end