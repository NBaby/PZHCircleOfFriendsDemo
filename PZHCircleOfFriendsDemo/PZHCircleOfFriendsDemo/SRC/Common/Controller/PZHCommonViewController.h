//
//  MCCommonViewController.h
//  eCook
//
//  Created by apple on 16/1/4.
//
//

#import <UIKit/UIKit.h>

typedef  void (^ErrorBlock)();
@interface PZHCommonViewController : UIViewController
///开始在某View上显示加载页面,默认是透明的
- (void)startLoadingInView:(UIView *)targetView;
///开始加载
- (void)startLoadingInView:(UIView *)targetView withBackgroundColor:(UIColor *)color;
///停止加载
- (void)stopLoadingInView:(UIView *)targetView;
///显示出错页面
- (void)showErrorInView:(UIView *)targetView andBlock:(void (^)())block;
;
///显示出错页面加背景色
- (void)showErrorInView:(UIView *)targetView withBackgroundColor:(UIColor *)color andBlock:(void (^)())block;

///显示出错页面含错误码
- (void)showErrorInView:(UIView *)targetView errorCode:(NSInteger)errorCode andBlock:(void (^)())block;
///显示出错页面加背景色含错误码
- (void)showErrorInView:(UIView *)targetView withBackgroundColor:(UIColor *)color errorCode:(NSInteger)errorCode andBlock:(void (^)())block;



///显示空白界面
- (void)showEmptyInView:(UIView *)targetView;
///显示空白界面加背景色
- (void)showEmptyInView:(UIView *)targetView withBackgroundColor:(UIColor *)color;
///显示带背景带文字的空白界面
- (void)showEmptyInView:(UIView *)targetView withBackgroundColor:(UIColor *)color text:(NSString *)text;
@end
@interface PZHLoadingView: UIView
@end