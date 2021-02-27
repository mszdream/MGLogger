//
//  MGCaching.h
//  MGLogger
//
//  Created by msz on 2021/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGCaching <NSObject>

// 通过字符串生成类
+ (nonnull id<MGCaching>)mg_create:(nonnull NSString *)string;

// 将自身存储内容转换成字符串，以便进行缓存
- (nonnull NSString *)mg_obj2Str;

- (nonnull NSString *)mg_className;

@end

NS_ASSUME_NONNULL_END
