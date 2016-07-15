//
//  TableViewCacheManager.m
//  MatchingPlatform
//
//  Created by nuomi on 16/3/18.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "TableViewCacheManager.h"
@interface TableViewCacheManager(){

    NSMutableArray <NSIndexPath *>* keyArray;
    NSMutableArray <NSNumber *>* valueArray;
}
@end


@implementation TableViewCacheManager
- (instancetype)init{
    self = [super init];
    if (self) {
        keyArray = [[NSMutableArray alloc]init];
        valueArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSNumber *)getHeightWithNSIndexPath:(NSIndexPath *)indexPatch{
    if (![keyArray containsObject:indexPatch]) {
        return @(0);
    }
    long num = [keyArray indexOfObject:indexPatch];
    return [valueArray objectAtIndex:num];
}

- (void)setHeightWithNSIndexPatch:(NSIndexPath *)indexPatch andValue:(NSNumber *)num{
    
    [keyArray addObject:indexPatch];
    [valueArray addObject:num];
}
- (void)clearAllCache{
    [keyArray removeAllObjects];
    [valueArray removeAllObjects];
}
#pragma mark 清除指定section缓存
- (void)clearHeightWithSection:(NSInteger )section{
    for (int i = 0 ; i < keyArray.count ;i++) {
        NSIndexPath * indexPatch = keyArray[i];
        if (indexPatch.section == section) {
            valueArray[i]=@(0);
        }
    }
}
@end
