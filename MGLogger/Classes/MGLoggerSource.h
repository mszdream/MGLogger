//
//  MGLoggerSource.h
//  MGLogger
//
//  Created by msz on 2020/12/24.
//

#import <Foundation/Foundation.h>
#import "MGConfig.h"

NS_ASSUME_NONNULL_BEGIN

/////////////////////////////////////////////////////////////////////
/////////////////////// RunLoopCustomSource /////////////////////
/////////////////////////////////////////////////////////////////////
@interface MGLoggerSource : NSObject

- (instancetype)initWithRunBlock:(BOOL(^)(NSArray<id<MGCaching>> *items))runBlock
                  maxReturnCount: (NSInteger)count;

- (void)addToCurrentRunLoop;    // runLoop中加入源
- (void)invalidate;             // runLoop中删除源

// Handler method
- (void)sourceFired;

// Client interface for registering commands to process
- (void)addCommand:(id<MGCaching>)data;
- (void)performCommand;
@end

NS_ASSUME_NONNULL_END
