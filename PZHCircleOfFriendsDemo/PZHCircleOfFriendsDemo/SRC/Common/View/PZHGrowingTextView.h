//
//  PZHGrowingTextView.h
//  nuomiText
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 com.nuomi. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol PZHGrowingTextViewDelegate <NSObject>
@optional
- (void)didTextViewHeightChange:(NSInteger )height;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView;

- (void)textViewDidChangeSelection:(UITextView *)textView;
@end
@interface PZHGrowingTextView : UIView
@property (assign,nonatomic) NSInteger maxHeight;
@property (assign,nonatomic) NSInteger minHeight;
@property (assign,nonatomic) UIEdgeInsets contentInset;
@property (strong,nonatomic) UIFont * font;
@property (weak,nonatomic) id <PZHGrowingTextViewDelegate> delegate;
@property (copy,nonatomic) NSString * placeHoder;
@property (copy,nonatomic) NSString * text;
@property (strong,nonatomic) UITextView *internalTextView;
- (instancetype)initWithFrame:(CGRect)frame;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
@end
