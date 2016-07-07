//
//  MCCommonViewController.m
//  eCook
//
//  Created by apple on 16/1/4.
//
//

#import "PZHCommonViewController.h"
@interface PZHCommonViewController (){
    PZHLoadingView * loadingView;
    ErrorBlock errorBlock ;
}
@end
@implementation PZHCommonViewController
- (void)startLoadingInView:(UIView *)targetView{
    [self startLoadingInView:targetView withBackgroundColor:[UIColor clearColor]];
}
- (void)startLoadingInView:(UIView *)targetView withBackgroundColor:(UIColor *)color{
    [loadingView removeFromSuperview];
    BOOL useAutoLayout = NO;
    if (targetView.constraints.count > 0 ) {
        useAutoLayout = YES;
    }
    else {
        UIView * view = targetView.superview;
        for (NSLayoutConstraint * constraint in view.constraints ) {
            if (constraint.firstItem == targetView || constraint.secondItem == targetView) {
                useAutoLayout = YES;
                break;
            }
        }
    }
    ///覆盖在上面的view
    loadingView = [[PZHLoadingView alloc]init];
    //    loadingView.backgroundColor = ColorBaseBackground;
    UIImageView * imageView = [[UIImageView alloc]init];
    [loadingView addSubview:imageView];
    loadingView.backgroundColor = color;
    [targetView addSubview:loadingView];
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loadingView);
        make.centerY.equalTo(loadingView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    //构造gif动画
    NSMutableArray * gifPictures = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< 9 ; i ++) {
        NSString * imageName = [NSString stringWithFormat:@"pig%d",i+1];
        UIImage * image = [UIImage imageNamed:imageName];
        [gifPictures addObject:image];
    }
    imageView.animationImages = gifPictures;
    imageView.animationDuration = 9.0/10;
    [imageView startAnimating];
    if (useAutoLayout ) {
        //如果使用useAutoLayout
        [loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(targetView);
            make.trailing.equalTo(targetView);
            make.top.equalTo(targetView);
            make.bottom.equalTo(targetView);
        }];
        
    }
    else {
        //如果没有使用useAutoLayout
        loadingView.frame = self.view.bounds;
        [targetView addSubview:loadingView];
    }
}
- (void)stopLoadingInView:(UIView *)targetView{
    [loadingView removeFromSuperview];
    for (UIView *item in [targetView subviews]) {
        if ([item isKindOfClass:[PZHLoadingView class]]) {
            [item removeFromSuperview];
        }
    }
}



///显示出错页面
- (void)showErrorInView:(UIView *)targetView andBlock:(void (^)())block{
    [self showErrorInView:targetView withBackgroundColor:[UIColor clearColor] errorCode:-1 andBlock:block];
}
///显示出错页面加背景色
- (void)showErrorInView:(UIView *)targetView withBackgroundColor:(UIColor *)color andBlock:(void (^)())block {
    [self showErrorInView:targetView withBackgroundColor:color errorCode:-1 andBlock:block];
}




///显示出错页面含错误码
- (void)showErrorInView:(UIView *)targetView errorCode:(NSInteger)errorCode andBlock:(void (^)())block{
    [self showErrorInView:targetView withBackgroundColor:[UIColor clearColor] errorCode:errorCode andBlock:block];
}
///显示出错页面加背景色含错误码
- (void)showErrorInView:(UIView *)targetView withBackgroundColor:(UIColor *)color errorCode:(NSInteger)errorCode andBlock:(void (^)())block{
    
    NSString *code = [NSString stringWithFormat:@"%zi",(int)errorCode];
    if(errorCode == -1) {
        code = [NSString stringWithFormat:@"网络异常，请稍后刷新"];
    } else {
        code = [NSString stringWithFormat:@"网络异常，请稍后刷新(%@)",code];
    }

       [loadingView removeFromSuperview];
    BOOL useAutoLayout = NO;
    if (targetView.constraints.count > 0 ) {
        useAutoLayout = YES;
    }
    else {
        UIView * view = targetView.superview;
        for (NSLayoutConstraint * constraint in view.constraints ) {
            if (constraint.firstItem == targetView || constraint.secondItem == targetView) {
                useAutoLayout = YES;
                break;
            }
        }
    }
    errorBlock = block;
    ///覆盖在上面的view
    loadingView = [[PZHLoadingView alloc]init];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = code;
    titleLabel.textColor = ColorNewTextGrayLight;
    titleLabel.font = FontRealityMiddle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:titleLabel];
    UILabel * subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.font = FontRealitySmall;
    subTitleLabel.textColor = ColorNewTextGrayLight;
    subTitleLabel.text = @"轻触屏幕重新加载";
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:subTitleLabel];
    //点击按钮
    UIButton * tapBtn = [[UIButton alloc]init];
    [loadingView addSubview:tapBtn];
    [tapBtn addTarget:self action:@selector(tapErrorBtn) forControlEvents:UIControlEventTouchUpInside];
    
    loadingView.backgroundColor = color;
    
    [targetView addSubview:loadingView];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loadingView);
        make.centerY.equalTo(loadingView).offset(-12);
        make.leading.equalTo(loadingView).offset(10);
        make.trailing.equalTo(loadingView).offset(-10);
    }];
    
    [subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loadingView);
        make.centerY.equalTo(loadingView).offset(12);
        make.leading.equalTo(loadingView).offset(10);
        make.trailing.equalTo(loadingView).offset(-10);
    }];
    [tapBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loadingView);
        make.bottom.equalTo(loadingView);
        make.leading.equalTo(loadingView);
        make.trailing.equalTo(loadingView);
    }];
    
    if (useAutoLayout ) {
        //如果使用useAutoLayout
        [loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(targetView);
            make.trailing.equalTo(targetView);
            make.top.equalTo(targetView);
            make.bottom.equalTo(targetView);
        }];
        
    }
    else {
        //如果没有使用useAutoLayout
        loadingView.frame = self.view.bounds;
        [targetView addSubview:loadingView];
    }
}


///显示空白界面
- (void)showEmptyInView:(UIView *)targetView{
    [self showEmptyInView:targetView withBackgroundColor:[UIColor clearColor]];
}
///显示空白界面加背景色
- (void)showEmptyInView:(UIView *)targetView withBackgroundColor:(UIColor *)color{
    [self showEmptyInView:targetView withBackgroundColor:color text:@"暂无内容"];
}
///显示带背景带文字的空白界面
- (void)showEmptyInView:(UIView *)targetView withBackgroundColor:(UIColor *)color text:(NSString *)text{
    [loadingView removeFromSuperview];
    BOOL useAutoLayout = NO;
    if (targetView.constraints.count > 0 ) {
        useAutoLayout = YES;
    }
    else {
        UIView * view = targetView.superview;
        for (NSLayoutConstraint * constraint in view.constraints ) {
            if (constraint.firstItem == targetView || constraint.secondItem == targetView) {
                useAutoLayout = YES;
                break;
            }
        }
    }
    ///覆盖在上面的view
    loadingView = [[PZHLoadingView alloc]init];
    loadingView.backgroundColor = color;
    loadingView.userInteractionEnabled = NO;
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = text;
    titleLabel.textColor = ColorNewTextGrayLight;
    titleLabel.font = FontRealityNormal;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:titleLabel];
    
    UIImageView * pigImageView = [[UIImageView alloc]init];
    pigImageView.image = [UIImage imageNamed:@"nothing"];
    [loadingView addSubview:pigImageView];
    
    
    
    [targetView addSubview:loadingView];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loadingView);
        make.centerY.equalTo(loadingView).offset(-24);
        make.leading.equalTo(loadingView).offset(10);
        make.trailing.equalTo(loadingView).offset(-10);
    }];
    
    [pigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loadingView);
        make.centerY.equalTo(loadingView).offset(-75);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(80);
    }];
    
    if (useAutoLayout ) {
        //如果使用useAutoLayout
        [loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
            if ([targetView isKindOfClass:[UIScrollView class]]) {
                make.width.mas_equalTo(screenWidth);
                make.height.mas_equalTo(screenHeight);
            }
            make.leading.equalTo(targetView);
            make.trailing.equalTo(targetView);
            make.top.equalTo(targetView);
            make.bottom.equalTo(targetView);
        }];
        
    }
    else {
        //如果没有使用useAutoLayout
        loadingView.frame = self.view.bounds;
        [targetView addSubview:loadingView];
    }
}
#pragma mark 出错点击事件
- (void)tapErrorBtn{
    [loadingView removeFromSuperview];
    if (errorBlock) {
        errorBlock();
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
@end
@implementation PZHLoadingView
@end
