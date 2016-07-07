//
//  UIViewExtension.h
//  eCook
//
//  Created by Jehy Fan on 14-8-8.
//
//

#import <Foundation/Foundation.h>

@interface UIView(UIViewExtension)

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGFloat originX;
@property(nonatomic) CGFloat originY;

@property(nonatomic) CGSize size;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat cornerRadius;

- (void)removeAllSubviews;

@end

@interface UILabel(UILabelExtension)

- (CGSize)textSize;
- (CGSize)textSizeWithSize:(CGSize)size;
- (void)fixHeight;

@property(nonatomic) CGFloat miniFontSize;

@end

@interface UIButton(UIButtonExtension)

- (CGSize)titleSize;


@end

@interface UIAlertView(UIAlertViewExtension)

+ (void)showTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

+ (void)showTitle:(NSString *)title message:(NSString *)message;

+ (void)showMessage:(NSString *)message;
+ (void)showTitle:(NSString *)title;

+ (void)showTitle:(NSString *)title delegate:(id)delegate;

@end


@interface UISearchBar(UISearchBarExtension)

- (void)resetStyle;

- (void)setButtonStyle;


@end


@interface UITextField(UITextFieldExtension)


-(void)setTextFieldLeftPadding:(CGFloat)leftWidth;
-(void)setTextFieldPadding:(CGFloat)padding;

@end



@interface UITableView(UITableViewExtension)

- (void)deleteRow:(NSInteger)row inSection:(NSInteger)section;
- (void)deleteRow:(NSInteger)row;

@end

@interface UIScrollView(UIScrollViewExtension)

- (void)scrollToTop:(BOOL)animated;
- (void)scrollToBottom:(BOOL)animated;

@end
