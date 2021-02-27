//
//  MGLoggerSource.m
//  MGLogger
//
//  Created by msz on 2020/12/24.
//

#import "MGLoggerSource.h"
#import "MGLogger.h"
#import "MGLoggerQueue.h"

/**
 *  处理例程
 *  在输入源被告知（signal source）时，调用这个处理例程，这儿只是简单的调用了 [obj sourceFired]方法
 *
 */
void RunLoopSourcePerformRoutine (void *info) {
    MGLoggerSource *obj = (__bridge MGLoggerSource*)info;
    [obj sourceFired];
}

/////////////////////////////////////////////////////////////////////
/////////////////////// RunLoopCustomSource /////////////////////
/////////////////////////////////////////////////////////////////////
@interface MGLoggerSource()
@property (nonatomic, strong) MGLoggerQueue *commandQueue;

@property (nonatomic, copy) BOOL(^runBlock)(NSArray<id<MGCaching>> *items);
@property (nonatomic, assign) CFRunLoopSourceRef runLoopSource;
@property (nonatomic, assign) NSInteger returnMaxCount;
@end

@implementation MGLoggerSource

- (instancetype)initWithRunBlock:(BOOL(^)(NSArray<id<MGCaching>> *items))runBlock
                  maxReturnCount: (NSInteger)count {
    self = [super init];
    if (self) {
        self.commandQueue = [[MGLoggerQueue alloc] init];
        
        self.runBlock = runBlock;
        self.returnMaxCount = count;
        // 创建源
        CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
            NULL,
            NULL,
            RunLoopSourcePerformRoutine};
        self.runLoopSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    }
    
    return self;
}

// runLoop中加入源
- (void)addToCurrentRunLoop {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, self.runLoopSource, kCFRunLoopDefaultMode);
}

// runLoop中删除源
- (void)invalidate {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopRemoveSource(runLoop, self.runLoopSource, kCFRunLoopDefaultMode);
}

// 给源发信号，此时就会执行相应回调函数
- (void)performCommand {
    // 标记为待处理
    if (self.runLoopSource && self.commandQueue.count > 0) {
        CFRunLoopSourceSignal(self.runLoopSource);

        CFRunLoopRef runLoop = CFRunLoopGetCurrent();
        CFRunLoopWakeUp(runLoop);
    }
}

// Handler method
- (void)sourceFired {
    NSArray *arrayObj = [self.commandQueue pop:self.returnMaxCount];
    if (arrayObj.count > 0) {
        if (YES == self.runBlock(arrayObj)) {
            [self.commandQueue removeFromFront:arrayObj.count];
        }
    }
}

// Client interface for registering commands to process
- (void)addCommand:(id<MGCaching>)data {
    [self.commandQueue push:data];
}

#pragma mark --property
- (NSInteger)returnMaxCount {
    return _returnMaxCount > 0 ? _returnMaxCount : 1;
}

@end

