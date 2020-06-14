//
//  AppDelegate.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppDelegate.h"

#import "AppTabbarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (UIWindow *)window {
    id appDelegate = UIApplication.sharedApplication.delegate;
    if ([appDelegate isKindOfClass:AppDelegate.class]) {
        return ((AppDelegate *)appDelegate).window;
    }
    return nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available (iOS 13, *)) {
        
    } else {
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        AppTabbarController *tabbar = [[AppTabbarController alloc] init];
        self.window.rootViewController = tabbar;
        [self.window makeKeyAndVisible];
        
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
