//
//  MGLogger.m
//  MGLogger
//
//  Created by msz on 2020/12/24.
//

#import "MGLogger.h"
#import "MGLoggerSource.h"

@interface MGLogger()
@property (atomic, strong) MGConfig *config;
@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, strong) MGLoggerSource *source;
@end

@implementation MGLogger

+ (MGLogger *)sharedInstance {
    static MGLogger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MGLogger alloc] init];
    });
    
    return instance;
}

+ (void)mg_startWithConfig: (void(^)(MGConfig *cfg))cfgBlock {
    MGConfig *config = [[MGConfig alloc] init];
    cfgBlock(config);
    
    MGLogger *loger = [self sharedInstance];
    loger.config = config;
    loger.source = [[MGLoggerSource alloc] initWithRunBlock:config.runBlock maxReturnCount:config.maxReturnCount];
    [loger startNewThread];
}

+ (void)mg_stop {
    MGLogger *loger = [self sharedInstance];
    [loger.thread cancel];
}

- (void)startNewThread {
    self.thread = [[NSThread alloc] initWithTarget:self
                                          selector:@selector(mgLogTrigger)
                                            object:nil];
    [self.thread setName:@"MGLoger--Thread"];
    [self.thread start];
}

- (void)mgLogTrigger {
    // 添加自定义源
    [self.source addToCurrentRunLoop];
    
    // 使用runloop挂起线程
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSThread *thread = [NSThread currentThread];
    while (!thread.isCancelled) {
        [self.source performCommand];
        BOOL ret = [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:self.config.detectionInterval]];
        NSLog(@"ret = %d", ret);
    }
    
    [self.source invalidate];
}

- (void)addLogContent:(id<MGCaching>)logObj {
    [self.source addCommand:logObj];
}

@end


void mglogger_add_content(id<MGCaching> obj) {
    MGLogger *loger = [MGLogger sharedInstance];
    [loger addLogContent:obj];
}
