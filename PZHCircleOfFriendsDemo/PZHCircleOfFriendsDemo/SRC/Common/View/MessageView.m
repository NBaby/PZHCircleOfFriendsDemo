//
//  MessageView.m
//  eCook
//
//  Created by 军辉 范 on 12-1-4.
//  Copyright (c) 2012年 Hangzhou Mo Chu Technology Co., Ltd. All rights reserved.
//

#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>


#define DefaultDuration 2.0

static MessageView *instance = nil;

@interface MessageView()


@end

@implementation MessageView


@synthesize baseY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
            space = 10;
        
        //base----------------------
        backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.72];
        backgroundView.layer.masksToBounds = YES;
        backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        [self setBackgroundLayer:YES];
        [self addSubview:backgroundView];
        
        textLabel = [[UILabel alloc] init];
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.numberOfLines = 0;
        [self addSubview:textLabel];
        
        indicatorView = [[UIActivityIndicatorView alloc] init];
        indicatorView.hidesWhenStopped = YES;
        [self addSubview:indicatorView];
        
       
            
            textLabel.font = [UIFont boldSystemFontOfSize:16];
            
            indicatorView.frame = CGRectMake(20, 30, 20, 20);
            indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            indicatorSize = 20;
        
        baseY = screenHeight * (1 - 0.618);
    }
    return self;
}



+ (MessageView *)getInstance
{
    if (instance == nil) {
        instance = [[MessageView alloc] init];
        instance.baseY += 64;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:instance];
    }
    
    return instance;
}

- (void)setBackgroundLayer:(BOOL)set
{
    if (set) {
        backgroundView.layer.cornerRadius = space / 2;
        backgroundView.layer.shadowRadius = space / 10;
        backgroundView.layer.shadowOpacity = 0.6;        
        backgroundView.layer.shadowOffset = CGSizeMake(0, space / 20);
        backgroundView.clipsToBounds = NO;
    } else {
        backgroundView.layer.cornerRadius = 0;
        backgroundView.layer.shadowRadius = 0;
        backgroundView.layer.shadowOpacity = 0;
        backgroundView.layer.shadowOffset = CGSizeMake(0, -3);
        backgroundView.clipsToBounds = YES;
    }
}

#pragma mark - hide

- (void)animationDidStoped
{
    [indicatorView stopAnimating];
}

- (void)hideMessageView
{
    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationDuration:0.64];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStoped)];
    self.alpha = 0;
    
    [UIView commitAnimations];
}

- (void)stop
{
    [self hideMessageView];
}

- (void)stopImmediately
{
    
    [indicatorView stopAnimating];
    self.alpha = 0;
}

- (void)hideMessageViewByTimer:(NSTimer *)timer
{
    [self hideMessageView];
}

#pragma mark - showMessage 长条文本框

- (void)showMessage:(NSString *)message duration:(float)duration
{
    
    [self.superview bringSubviewToFront:self];
    
    textLabel.hidden = NO;
    textLabel.text = message;
    
    [indicatorView stopAnimating];
    
    CGSize textSize = [textLabel textSizeWithSize:CGSizeMake(screenWidth - space * 4, MAXFLOAT)];
    
    self.frame = CGRectMake((screenWidth - textSize.width) / 2 - space,
                            baseY - (textSize.height + space) / 2,
                            textSize.width + (space * 2),
                            textSize.height + space);
    
    backgroundView.frame = CGRectMake(0, 0, textSize.width + (space * 2), textSize.height + space);
    textLabel.frame = CGRectMake(space, space / 2, textSize.width, textSize.height);
    
    if (self.alpha == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.alpha = 1;
        [UIView commitAnimations];
    }
    
    
    if (hideTimer.isValid) {
        [hideTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:duration]];
    } else {
       
        hideTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                      target:self
                                                    selector:@selector(hideMessageViewByTimer:)
                                                    userInfo:nil
                                                     repeats:NO];
    }
}

- (void)showMessage:(NSString *)message
{
    [self showMessage:message duration:DefaultDuration];
}

- (void)showNetworkError
{
    [self showMessage:@"网络异常, 请到较好的网络环境重试~" duration:DefaultDuration];
}

#pragma mark - starProcessing 方形指示框
- (void)startProcessing:(NSString *)content
{   
    [self.superview bringSubviewToFront:self];
    
    [self setBackgroundLayer:YES];
    
    textLabel.hidden = NO;
    textLabel.text = content;

    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.alpha = 1;
    
    CGSize textSize = textLabel.textSize;
    
    backgroundView.frame = CGRectMake((screenWidth - textSize.width - (space * 5) - indicatorSize) / 2 ,
                                      baseY - (indicatorSize + space * 6) / 2,
                                      textSize.width + (space * 5) + indicatorSize,
                                      indicatorSize + space * 6);
    
    textLabel.frame = CGRectMake(backgroundView.frame.origin.x + (space * 3) + indicatorSize,
                                 backgroundView.frame.origin.y + space * 3,
                                 textSize.width,
                                 indicatorSize);
    
    indicatorView.frame = CGRectMake(backgroundView.frame.origin.x + 2 * space, backgroundView.frame.origin.y + 3 * space, indicatorSize, indicatorSize);

    [indicatorView startAnimating];
}

- (void)startLoading
{
    [self startProcessing:@"加载中..."];    
}

- (void)startSending
{
    [self startProcessing:@"发送中..."];
}

- (void)startDeal
{
    [self startProcessing:@"处理中..."];
}

#pragma mark - startDealingWithTitle 全屏指示框
- (void)startDealingWithTitle:(NSString *)title
{
    [self.superview bringSubviewToFront:self];
    
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight + 40);
    self.alpha = 1;
    
    [self setBackgroundLayer:NO];
    
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    textLabel.text = title;
    
    float textWidth = 0;
    
    if (title.length == 0) {
        textLabel.frame = CGRectZero;
    } else {
        CGSize textSize = textLabel.textSize;
        
        textWidth = space + textSize.width;
        
        textLabel.frame = CGRectMake((screenWidth - (indicatorSize + textWidth)) / 2 + indicatorSize + space,
                                     baseY,
                                     textSize.width,
                                     indicatorSize);
    }
    
    indicatorView.frame = CGRectMake((screenWidth - (indicatorSize + textWidth)) / 2,
                                     baseY,
                                     indicatorSize,
                                     indicatorSize);
    
    [indicatorView startAnimating];
}

- (void)startProgressing
{
    [self startDealingWithTitle:nil];
}

- (void)beginLogin
{
    [self startDealingWithTitle:@"登录中..."];
}

- (void)beginBind
{
    [self startDealingWithTitle:@"绑定中..."];
}

- (void)startDeliver
{
    [self startDealingWithTitle:@"发表中..."];
}

#pragma mark - Image 图片
- (void)showUploadImage:(float)newProgress
{
    if (circleProgressView.alpha == 0) {
        [self.superview bringSubviewToFront:self];
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        self.alpha = 1;
        
        [self setBackgroundLayer:YES];
        
        [indicatorView stopAnimating];
        
        backgroundView.frame = CGRectMake((screenWidth - 14.4 * space) / 2,
                                          (screenHeight - 14.4 * space) / 2,
                                          14.4 * space,
                                          14.4 * space);
        textLabel.text = @"上传中...";
        textLabel.hidden = NO;
        textLabel.frame = CGRectMake((screenWidth - 14.4 * space) / 2,
                                     (screenHeight - 14.4 * space) / 2 + 10.8 * space,
                                     14.4 * space,
                                     textLabel.font.lineHeight);
        
        if (circleProgressView == nil) {
            circleProgressView = [[CircleProgressView alloc] init];
            circleProgressView.frame = CGRectMake((14.4 * space - 7 * space) / 2, 2.5 * space, 7 * space, 7 * space);
            [backgroundView addSubview:circleProgressView];
            circleProgressView.trackColor = [UIColor colorWithWhite:80.0 / 255.0 alpha:1];
            circleProgressView.progressColor = [UIColor colorWithRed:1 green:118.0 / 255.0 blue:0 alpha:1];
            circleProgressView.progressWidth = 0.7 * space;
            
            cancelLabel = [[UILabel alloc] init];
            cancelLabel.backgroundColor = [UIColor colorWithRed:1 green:118.0 / 255.0 blue:0 alpha:1];
            cancelLabel.text = @"取消";
            cancelLabel.textColor = [UIColor whiteColor];
            cancelLabel.textAlignment = NSTextAlignmentCenter;
            cancelLabel.font = [UIFont systemFontOfSize:1.4 * space];
            cancelLabel.layer.masksToBounds = YES;
            cancelLabel.layer.cornerRadius = 2.1 * space;
            cancelLabel.frame = CGRectMake((14.4 * space - 4.2 * space) / 2, 3.9 * space, 4.2 * space, 4.2 * space);
            [backgroundView addSubview:cancelLabel];
            
            cancelButton = [[UIButton alloc] init];
            [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            cancelButton.frame = circleProgressView.frame;
            [backgroundView addSubview:cancelButton];
        }
        
        circleProgressView.alpha = 1;
        cancelLabel.alpha = 1;
        cancelButton.alpha = 1;
    }
    
    destProgress = newProgress;
    
    span = (destProgress - circleProgressView.progress) / 10;//10 ≈ 0.36 / 0.04;
    
    [self performSelector:@selector(setProgress) withObject:nil afterDelay:0.04];//0.04 ≈ 1.0 / 24.0
}

- (void)setProgress
{
    if (circleProgressView.progress < destProgress) {
        float progress = circleProgressView.progress + span;
        if (progress > 1.0) {
            progress = 1.0;
        }
        circleProgressView.progress = progress;
        textLabel.text = [NSString stringWithFormat:@"图片上传%i\%%", (int)(progress * 100)];
        
        [self performSelector:@selector(setProgress) withObject:nil afterDelay:0.04];
        
    }
}

- (void)stopUploadImage
{
    destProgress = 0;
    circleProgressView.progress = 0;
    
    self.alpha = 0;
    
    circleProgressView.alpha = 0;
    cancelLabel.alpha = 0;
    cancelButton.alpha = 0;
}

- (void)cancelButtonPressed
{
    [self stopUploadImage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelUploadImage" object:nil];
}

#pragma mark - Audio 音频
- (void)showRecordAudioWave:(float)wave second:(int)second
{
    if (micImageView == nil) {
        //audio----------------------
        micImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon_mic_big.png"]];
        micImageView.hidden = YES;
        [self addSubview:micImageView];
        
        secondLabel = [[UILabel alloc] init];
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.textColor = [UIColor whiteColor];
        secondLabel.font = [UIFont boldSystemFontOfSize:24];
        secondLabel.hidden = YES;
        [self addSubview:secondLabel];
        
        waveView = [[UIView alloc] init];
        waveView.hidden = YES;
        waveView.backgroundColor = [UIColor colorWithRed:1 green:118.0 / 255.0 blue:0 alpha:1]
;
        waveView.layer.masksToBounds = YES;
        [self addSubview:waveView];
        
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = [UIColor whiteColor];
        [waveView addSubview:coverView];
     
    }
    
    if (micImageView.hidden == YES) {
        [self.superview bringSubviewToFront:self];
        
        self.frame = CGRectMake(0,  0, screenWidth, screenHeight + 40);
        self.alpha = 1;
        
        [self setBackgroundLayer:YES];
        
        textLabel.hidden = YES;
        [indicatorView stopAnimating];
        
        micImageView.hidden = NO;
        waveView.hidden = NO;
        secondLabel.hidden = NO;
        
        backgroundView.frame = CGRectMake((screenWidth - space * 12.8) / 2,
                                          (screenHeight - space * 12.8) / 2,
                                          space * 12.8,
                                          space * 12.8);
        
        micImageView.frame = CGRectMake((screenWidth - 47) / 2, (screenHeight - 65) / 2, 47, 65);
        
        secondLabel.frame = CGRectMake((screenWidth - space * 12.8) / 2 + space * 10,
                                       (screenHeight - space * 12.8) / 2 + space,
                                       space * 3,
                                       space * 2);
        
        waveView.layer.cornerRadius = 11.75;
        waveView.frame = CGRectMake(micImageView.frame.origin.x + 11.5, micImageView.frame.origin.y + 4.5, 23.5, 37.5 );
    }
    
    if (second >= 0) {
        secondLabel.text = [NSString stringWithFormat:@"%i", second];
    }
    
    UIView *coverView = waveView.subviews.lastObject;
    coverView.frame = CGRectMake(0, 0, 23.5, 37.5 * (1 - wave));
}

- (void)stopRecordAudioWave
{
    waveView.hidden = YES;
    secondLabel.hidden = YES;
    secondLabel.text = nil;
    micImageView.hidden = YES;
    
    indicatorView.frame = CGRectMake((screenWidth - indicatorSize) / 2,
                                     (screenHeight - indicatorSize) / 2,
                                     indicatorSize,
                                     indicatorSize);
    [indicatorView startAnimating];
    
    [self hideMessageView];
}

@end
