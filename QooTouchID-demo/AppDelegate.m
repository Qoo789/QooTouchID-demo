//
//  AppDelegate.m
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PCCircleViewConst.h"
#import "QOOGestureVerifyVC.h"
#import "QOOGestureSettingVC.h"
#import "QOOTouchIDTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([PCCircleViewConst getGestureWithKey:kFingerprintVerifyKey]) {
        // 当前有开启 Touch ID
        QOOGestureSettingVC *vc = [[QOOGestureSettingVC alloc] init];
        vc.type = GestureSettingVCTypeLogin;
        self.window.rootViewController = vc;
        
        [QOOTouchIDTool fingerprintVerifyWithType:FingerprintVerifyTypeVarify andReply:^(BOOL success, NSError * _Nullable error, NSString *msg) {
            if (success) {
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
                self.window.rootViewController = nav;
            }
        }];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
        self.window.rootViewController = nav;
    }
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 程序进入后台, 记录当前时间
    NSDate *enterBackgroundTime = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:enterBackgroundTime forKey:kEnterBackgroundTimeKey];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    // 程序即将进入前台, 取出进入后台的时间做对比
    NSDate *enterBackgroundTime = [[NSUserDefaults standardUserDefaults] valueForKey:kEnterBackgroundTimeKey];
    NSDate *currentTime = [NSDate date];
    NSLog(@"程序进入后台时间为 -- %@, 当前时间为 -- %@", enterBackgroundTime, currentTime);
    
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据, 这里需要秒
    NSCalendarUnit unit = NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:enterBackgroundTime toDate:currentTime options:0];
    NSLog(@"前后时间差是%ld秒", dateCom.second);
    if (dateCom.second >= 10) {
        // 进入后台超过10秒, 需要手势解锁
        if ([PCCircleViewConst getGestureWithKey:gestureFinalSaveKey]) {
            
            UIViewController *visibleVC = [QOOTouchIDTool visibleController];
            
            // 验证
            QOOGestureSettingVC *vc = [[QOOGestureSettingVC alloc] init];
            vc.type = GestureSettingVCTypeEnterForeground;
            [visibleVC presentViewController:vc animated:YES completion:^{
                
                [QOOTouchIDTool fingerprintVerifyWithType:FingerprintVerifyTypeVarify andReply:^(BOOL success, NSError * _Nullable error, NSString *msg) {
                    if (success) {
                        [visibleVC dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }];
        }
    } else {
        // 切换时间小于10秒 不需要手势或指纹解锁
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
