//
//  MGConfig.m
//  MGLogger
//
//  Created by msz on 2020/12/25.
//

#import "MGConfig.h"

@implementation MGConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.runBlock = ^BOOL(NSArray<id<MGCaching>> * _Nonnull items) {
            NSCAssert(NO, @"The block of runBlock not set!");
            return NO;
        };
    }
    
    return self;
}

- (NSTimeInterval)detectionInterval {
    return _detectionInterval > 0 ? _detectionInterval : 1.0f;
}

- (NSInteger)maxReturnCount {
    return _maxReturnCount > 0 ? _maxReturnCount : 1;
}

@end
