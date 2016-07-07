//
//  UIViewExtension.m
//  eCook
//
//  Created by Jehy Fan on 14-8-8.
//
//

#import "UIExtension.h"
#import "NSExtension.h"

@implementation UIView(UIViewExtension)

- (void)setOrigin:(CGPoint)o
{
    CGRect frame = self.frame;
    frame.origin.x = o.x;
    frame.origin.y = o.y;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOriginX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setSize:(CGSize)s
{
    CGRect frame = self.frame;
    frame.size.width = s.width;
    frame.size.height = s.height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setWidth:(CGFloat)w
{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)h
{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    
    if (radius == 0) {
        self.layer.masksToBounds = NO;
    } else {
        self.layer.masksToBounds = YES;
    }
    
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

@end


@implementation UITextField(UITextFieldExtension)

-(void)setTextFieldLeftPadding:(CGFloat)leftWidth
{
    CGRect frame = self.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftview;
}

-(void)setTextFieldPadding:(CGFloat)padding
{
    CGRect frame = self.frame;
    frame.size.width = padding;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftview;
    
    UIView *rightview = [[UIView alloc] initWithFrame:frame];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = rightview;
}

@end



@implementation UILabel(UILabelExtension)



- (CGSize)textSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    return [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:options attributes:attributes context:nil].size;
    
//    return [self.text sizeWithFont:self.font
//                 constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
//                     lineBreakMode:self.lineBreakMode];
}

- (CGSize)textSizeWithSize:(CGSize)size
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    return [self.text boundingRectWithSize:size options:options attributes:attributes context:nil].size;
//    return [self.text sizeWithFont:self.font
//                 constrainedToSize:size
//                     lineBreakMode:self.lineBreakMode];
}

- (void)fixHeight
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:options attributes:attributes context:nil].size;
//    CGSize size = [self.text sizeWithFont:self.font
//                        constrainedToSize:CGSizeMake(self.width, MAXFLOAT)
//                            lineBreakMode:self.lineBreakMode];
    
    if (self.numberOfLines != 0) {
        
        float maxHeight = self.numberOfLines * self.font.lineHeight + 1;
        if (size.height > maxHeight) {
            size.height = maxHeight;
        }
    }
    
    self.height = size.height;
}

- (void)setMiniFontSize:(CGFloat)size
{
    self.minimumScaleFactor = size / self.font.pointSize;
}

- (CGFloat)miniFontSize
{
    return self.minimumScaleFactor * self.font.pointSize;
}

@end


@implementation UIButton(UIButtonExtension)

- (CGSize)titleSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = self.titleLabel.lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:self.titleLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    return [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:options attributes:attributes context:nil].size;

    
//    return [self.currentTitle sizeWithFont:self.titleLabel.font
//                         constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
//                             lineBreakMode:self.titleLabel.lineBreakMode];
}



@end


@implementation UIAlertView(UIAlertViewExtension)

+ (void)showTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
 
}

+ (void)showTitle:(NSString *)title message:(NSString *)message
{
    [UIAlertView showTitle:title message:message delegate:nil];
}

+ (void)showMessage:(NSString *)message
{
    [UIAlertView showTitle:nil message:message delegate:nil];
}
+ (void)showTitle:(NSString *)title
{
    [UIAlertView showTitle:title message:nil delegate:nil];
}

+ (void)showTitle:(NSString *)title delegate:(id)delegate
{
    [UIAlertView showTitle:title message:nil delegate:delegate];
}

@end

@implementation UISearchBar(UISearchBarExtension)

- (void)resetStyle
{
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageWithSize:CGSizeMake(screenWidth, 3) color:ColorNavbar]];
    bgImage.frame = CGRectMake(0, 0, screenWidth, 44);
    [self insertSubview:bgImage atIndex:1];
 
    
}

- (void)setButtonStyle
{
    for (UIView *view in self.subviews) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
}

@end

@implementation UITableView(UITableViewExtension)

- (void)deleteRow:(NSInteger)row inSection:(NSInteger)section
{
    [self deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:section], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteRow:(NSInteger)row
{
    [self deleteRow:row inSection:0];
}

@end

@implementation UIScrollView(UIScrollViewExtension)

- (void)scrollToTop:(BOOL)animated
{
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}
- (void)scrollToBottom:(BOOL)animated
{
    float maxOffsetY = self.contentSize.height - self.height;
    if (maxOffsetY > 0) {
        [self setContentOffset:CGPointMake(0, maxOffsetY) animated:animated];
    }
}

@end

