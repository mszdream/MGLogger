//
//  MGConfig.h
//  MGLogger
//
//  Created by msz on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import "MGCaching.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGConfig : NSObject
// 检测时间，当队列为空时，每隔多长时间进行一次重新检测
@property(nonatomic, assign) NSTimeInterval detectionInterval;

// 最大返回数，当队列不为空时，一次性最多返回的数据数
@property (nonatomic, assign) NSInteger maxReturnCount;

/**
 处理日志：用户可以根据自己的需要处理日志，如上传日志，还是打印日志等等
 参数：items：返回一个日志数组，根据用户收集日志的顺序进行返回
 返回值：是否删除本地缓存的日志(日志收集后会先进行缓存，已防丢失)，YES表示删除
        本次返回的日志，否则表示不删除，注意不删除时下次返回时还会返回本次的数据，
        因此在日志处理操作完成后，要返回YES，以便可以删除本次返回的日志数据，且
        在下次可以返回后序新的日志数据
 注意：本Block会在异步线程中执行，因此在此方法中使用同步处理是最方便也是最简单的方式，
      否则就需要自己处理多个线程之间的同步问题
 */
@property (nonatomic, copy) BOOL(^runBlock)(NSArray<id<MGCaching>> *items);

@end

NS_ASSUME_NONNULL_END
