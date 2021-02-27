//
//  MGAppDelegate.m
//  MGLogger
//
//  Created by hello on 02/27/2021.
//  Copyright (c) 2021 hello. All rights reserved.
//

#import "MGAppDelegate.h"
#import <MGLogger/MGLogger.h>

@implementation MGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [MGLogger mg_startWithConfig:^(MGConfig * _Nonnull config) {
        // Detection interval when there are no elements in the queue
        config.detectionInterval = 10.0f;
        // Maximum number of records returned at one time
        config.maxReturnCount = 10;
        // Log processing block
        // param: items:Batch data returned at one time
        // return: Whether the returned current data is deleted from the cache, YES:deleted，otherwise will not to be deleted
        config.runBlock = ^BOOL(NSArray<id<MGCaching>> * _Nonnull items) {
            NSLog(@"arrObjs = %@", items);
            return YES;
        };
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
