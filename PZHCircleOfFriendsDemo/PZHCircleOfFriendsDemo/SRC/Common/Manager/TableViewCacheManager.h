//
//  TableViewCacheManager.h
//  MatchingPlatform
//
//  Created by nuomi on 16/3/18.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewCacheManager : NSObject

- (NSNumber *)getHeightWithNSIndexPath:(NSIndexPath *)indexPatch;

- (void)setHeightWithNSIndexPatch:(NSIndexPath *)indexPatch andValue:(NSNumber *)num;

///清除缓存
- (void)clearAllCache;
///清楚缓存
- (void)clearHeightWithSection:(NSInteger )section;
@end
