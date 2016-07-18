//
//  CircleProgressView.m
//  eCook
//
//  Created by Jehy Fan on 14-5-8.
//
//

#import "CircleProgressView.h"

@implementation CircleProgressView

@synthesize trackColor;
@synthesize progressColor;
@synthesize progress;
@synthesize progressWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        trackLayer = [CAShapeLayer new];
        [self.layer addSublayer:trackLayer];
        trackLayer.fillColor = nil;
        trackLayer.frame = self.bounds;
        
        progressLayer = [CAShapeLayer new];
        [self.layer addSublayer:progressLayer];
        progressLayer.fillColor = nil;
        progressLayer.lineCap = kCALineCapSquare;
        progressLayer.frame = self.bounds;
        
        //默认5
        self.progressWidth = 5;
    }
    return self;
}



- (void)setTrack
{
    trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                                               radius:(self.bounds.size.width - progressWidth) / 2
                                           startAngle:0
                                             endAngle:M_PI * 2
                                            clockwise:YES];;
    trackLayer.path = trackPath.CGPath;
}

- (void)setProgress
{
    progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                                                  radius:(self.bounds.size.width - progressWidth) / 2
                                              startAngle:- M_PI_2
                                                endAngle:(M_PI * 2) * progress - M_PI_2
                                               clockwise:YES];
    progressLayer.path = progressPath.CGPath;
}


- (void)setProgressWidth:(float)pWidth
{
    progressWidth = pWidth;
    trackLayer.lineWidth = pWidth;
    progressLayer.lineWidth = progressWidth;
    
    [self setTrack];
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)tColor
{
    trackLayer.strokeColor = tColor.CGColor;
}

- (void)setProgressColor:(UIColor *)pColor
{
    progressLayer.strokeColor = pColor.CGColor;
}

- (void)setProgress:(float)p
{
    progress = p;
    
    [self setProgress];
}

- (void)setProgress:(float)p animated:(BOOL)animated
{
    
}

@end
