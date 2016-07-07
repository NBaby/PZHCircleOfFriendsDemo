//
//  PZHGrowingTextView.m
//  nuomiText
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 com.nuomi. All rights reserved.
//

#import "PZHGrowingTextView.h"
@interface PZHGrowingTextView()<UITextViewDelegate>{
    UILabel * placeHoderLabel;
}
@end
@implementation PZHGrowingTextView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.minHeight = self.frame.size.height;
        self.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _internalTextView = [[UITextView alloc]initWithFrame:self.bounds];
        _internalTextView.delegate = self;
        [self addSubview:_internalTextView];
        [self resizeTextView:self.minHeight];
        self.font = [UIFont systemFontOfSize:13];
        placeHoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height)];
        [self addSubview:placeHoderLabel];
        placeHoderLabel.text = self.placeHoder;
        placeHoderLabel.font =[UIFont systemFontOfSize:13];
        placeHoderLabel.textColor = [UIColor grayColor];
        _internalTextView.returnKeyType = UIReturnKeyDone;
        
    }
    return self;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView];
    }
    
    if (textView.text.length == 0) {
        placeHoderLabel.hidden = NO;
    }
    else {
        placeHoderLabel.hidden = YES;
    }
    NSInteger newSizeH = _internalTextView.contentSize.height;
    if (newSizeH >self.maxHeight) {
        newSizeH = self.maxHeight;
    }
    if (newSizeH <= self.maxHeight){
        [UIView animateWithDuration:0.1f animations:^{
            NSInteger tempSizeH = newSizeH<self.minHeight?self.minHeight:newSizeH;
             [self resizeTextView:tempSizeH];
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(didTextViewHeightChange:)]) {
                [self.delegate didTextViewHeightChange:newSizeH];
            }
//             NSLog(@"高度变化为%ld",(long)newSizeH);
        }];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(selectortextViewShouldBeginEditing:)]) {
        return  [self.delegate textViewShouldBeginEditing:textView];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
      return   [self.delegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
      return   [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:textView];
    }
}
#pragma mark - ChangeFrame
-(void)resizeTextView:(NSInteger)newSizeH
{
    CGRect internalTextViewFrame = self.frame;
//    internalTextViewFrame.origin.y = internalTextViewFrame.origin.y - newSizeH+internalTextViewFrame.size.height;
    internalTextViewFrame.size.height = newSizeH; // + padding
    self.frame = internalTextViewFrame;
    
    internalTextViewFrame.origin.y = self.contentInset.top - self.contentInset.bottom;
    internalTextViewFrame.origin.x = self.contentInset.left;
    internalTextViewFrame.size.width = internalTextViewFrame.size.width -self.contentInset.left - self.contentInset.right;
    
    
    _internalTextView.frame = internalTextViewFrame;
}
#pragma mark - other
- (BOOL)becomeFirstResponder{
    return  [_internalTextView becomeFirstResponder];
    
}
- (BOOL)resignFirstResponder{
    return [_internalTextView resignFirstResponder];
   
}
#pragma mark- 懒加载
- (UIFont *)font{
    return _internalTextView.font;
}
- (void)setFont:(UIFont *)font{
    _internalTextView.font  = font;
}
- (void)setPlaceHoder:(NSString *)placeHoder{
    if (placeHoder ==nil) {
        placeHoder = @"";
    }
    placeHoderLabel.text = placeHoder;
    _placeHoder = placeHoder;
}
- (NSString *)text{
    return _internalTextView.text;
}
- (void)setText:(NSString *)text{
    if (text.length == 0) {
        placeHoderLabel.hidden = NO;
    }
    else {
         placeHoderLabel.hidden = YES;
    }
    _internalTextView.text=text;
}

@end
