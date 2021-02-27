//
//  MGLogger.h
//  MGLogger
//
//  Created by msz on 2020/12/24.
//

#import <Foundation/Foundation.h>
#import "MGConfig.h"
#import "MGCaching.h"
#import "NSString+MGCaching.h"
#import "NSMutableString+MGCaching.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGLogger : NSObject

+ (void)mg_startWithConfig: (void(^)(MGConfig *cfg))cfgBlock;
+ (void)mg_stop;

@end

#ifndef mgLog
#define mgLog mglogger_add_content
#endif
void mglogger_add_content(id<MGCaching> obj);

NS_ASSUME_NONNULL_END

