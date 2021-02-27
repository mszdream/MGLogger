//
//  NSMutableString+MGCaching.m
//  MGLogger
//
//  Created by msz on 2021/2/10.
//

#import "NSMutableString+MGCaching.h"

@implementation NSMutableString (MGCaching)

+ (nonnull id<MGCaching>)mg_create:(nonnull NSString *)string {
    return (id<MGCaching>)[NSMutableString stringWithString:string];
}

- (nonnull NSString *)mg_obj2Str {
    return self;
}

- (nonnull NSString *)mg_className {
    return @"NSMutableString";
}

@end
