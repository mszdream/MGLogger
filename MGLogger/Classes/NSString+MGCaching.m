//
//  NSString+MGCaching.m
//  MGLogger
//
//  Created by msz on 2021/2/10.
//

#import "NSString+MGCaching.h"

@implementation NSString (NSCaching)

+ (nonnull id<MGCaching>)mg_create:(nonnull NSString *)string {
    return (id<MGCaching>)string;
}

- (nonnull NSString *)mg_obj2Str {
    return self;
}

- (nonnull NSString *)mg_className {
    return @"NSString";
}

@end
