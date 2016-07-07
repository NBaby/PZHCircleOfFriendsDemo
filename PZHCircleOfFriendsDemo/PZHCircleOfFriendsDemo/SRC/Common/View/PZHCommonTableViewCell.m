//
//  MCCommonTableViewCell.m
//  iCook
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 Jehy Fan. All rights reserved.
//

#import "PZHCommonTableViewCell.h"

@interface PZHCommonTableViewCell(){

}
@end

@implementation PZHCommonTableViewCell

- (void)awakeFromNib {
    if (IOS_8_OR_LATER) {
        self.contentView.preservesSuperviewLayoutMargins = NO;
    }
}

- (void)setInfo:(id)info{
  
    
    
}
- (CGFloat)getHeightWidthInfo:(id)info{
    [self setInfo:info];
    [self layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height ;
    return  height;
}
@end
