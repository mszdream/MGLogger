//
//  MGLoggerQueue.h
//  MGLogger
//
//  Created by msz on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import "MGCaching.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGLoggerQueue : NSObject
@property (readonly) NSInteger count;

- (void)push:(id<MGCaching>)obj;
- (id<MGCaching>)pop;
- (NSArray<id<MGCaching>> *)pop:(NSInteger)count;
- (void)removeFromFront:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
