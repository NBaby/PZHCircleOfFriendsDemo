//
//  CircleProgressView.h
//  eCook
//
//  Created by Jehy Fan on 14-5-8.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface CircleProgressView : UIView {
    CAShapeLayer *trackLayer;
    UIBezierPath *trackPath;
    CAShapeLayer *progressLayer;
    UIBezierPath *progressPath;
    
    UIColor *trackColor;
    
    UIColor *progressColor;
    
    float progress;
    
    float progressWidth;
}

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) float progress;//0~1之间的数
@property (nonatomic) float progressWidth;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
