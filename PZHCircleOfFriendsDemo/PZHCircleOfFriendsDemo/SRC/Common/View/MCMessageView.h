//
//  MessageView.h
//  iCook
//
//  Created by Jehy Fan on 15/8/13.
//  Copyright (c) 2015年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MBProgressHUD.h>

@interface MCMessageView : UIView <MBProgressHUDDelegate> {
    MBProgressHUD *progressView;
}


+ (MCMessageView *)getInstance;


- (void)showText:(NSString *)text;
- (void)startDealing;
- (void)startLoading;

- (void)showMessage:(NSString *)message;

- (void)showNetworkError;

- (void)hide;

@end
