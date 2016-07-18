//
//  MessageView.h
//  eCook
//
//  Created by 军辉 范 on 12-1-4.
//  Copyright (c) 2012年 Hangzhou Mo Chu Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleProgressView.h"
#import "Extension.h"

@interface MessageView : UIView{
    UIView *backgroundView;
    
    UILabel *textLabel;
    UIActivityIndicatorView *indicatorView;
    
    UIImageView *micImageView;
    UIView *waveView;
    UILabel *secondLabel;
    
    CircleProgressView *circleProgressView;
    UILabel *cancelLabel;
    UIButton *cancelButton;
    
    float space;
    float baseY;
    float indicatorSize;
    
    NSTimer *hideTimer;
    
    float destProgress;
    float span;
}

@property(nonatomic) float baseY;

+ (MessageView *)getInstance;




- (void)stop;
- (void)stopImmediately;

- (void)showMessage:(NSString *)message duration:(float)duration;
- (void)showMessage:(NSString *)message;
- (void)showNetworkError;

- (void)startProcessing:(NSString *)content;
- (void)startLoading;
- (void)startSending;
- (void)startDeal;

- (void)startDealingWithTitle:(NSString *)title;
- (void)startProgressing;
- (void)beginLogin;
- (void)beginBind;
- (void)startDeliver;

- (void)showUploadImage:(float)newProgress;
- (void)stopUploadImage;

- (void)showRecordAudioWave:(float)wave second:(int)second;
- (void)stopRecordAudioWave;


@end
