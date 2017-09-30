//
//  QOOTouchIDTool.m
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#import "QOOTouchIDTool.h"

@implementation QOOTouchIDTool

+ (UIViewController *)visibleController {
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSAssert(vc != nil, @"没有获取到程序的根控制器");
    return [self getVisibleController:vc];
}

+ (UIViewController *)getVisibleController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = ((UITabBarController *)vc).selectedViewController;
        NSAssert(vc != nil, @"根控制器是tabbarController, 但没有获取到tabbar的子控制器");
        return [self getVisibleController:vc];
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).visibleViewController;
        NSAssert(vc != nil, @"没有获取到navigationController的子控制器");
        return [self getVisibleController:vc];
    }
    
    NSAssert(vc != nil, @"没有获取到当前控制器");
    return vc;
}


+ (void)fingerprintVerifyWithType:(FingerprintVerifyType)type andReply:(void(^_Nullable)(BOOL success, NSError * __nullable error, NSString *msg))reply {
    BOOL isVarify = type == FingerprintVerifyTypeVarify;
    BOOL fingerprintVerifyInUserDefaults = [[NSUserDefaults standardUserDefaults] boolForKey:kFingerprintVerifyKey];
    
    // 判断是否开启指纹
    if (isVarify ? fingerprintVerifyInUserDefaults : !fingerprintVerifyInUserDefaults) {
        
        if (@available(iOS 8.0, *)) { // 系统版本高于8.0, iOS 8之后才可以开启
            
            LAContext *context = [[LAContext alloc] init];
            context.maxBiometryFailures = @(3);
            context.localizedFallbackTitle = @"";
            context.localizedCancelTitle = @"取消";
            
            // 调用系统 API 检查 Touch ID 是否可用
            NSError *requestError;
            NSInteger policy;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
                policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
            } else {
                policy = LAPolicyDeviceOwnerAuthentication;
            }
            
            if ([context canEvaluatePolicy:policy error:&requestError]) { // 系统方法验证, 设备支持
                
                NSLog(@"Touch ID可以使用, 开始验证");
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            reply(success, nil, @"指纹验证成功");
                        });
                    } else {
                        NSString *msg;
                        switch (error.code) {
                            case LAErrorPasscodeNotSet:
                                // 没有在设备上设置密码
                                msg = @"设备上没有设置 Touch ID";
                                NSLog(@"%@", msg);
                                break;
                            case LAErrorTouchIDNotAvailable:
                                // 设备不支持TouchID
                                msg = @"设备不支持 Touch ID";
                                NSLog(@"%@", msg);
                                break;
                            case LAErrorTouchIDNotEnrolled:
                                // 设备没有注册TouchID
                                msg = @"设备没有注册过 Touch ID";
                                NSLog(@"%@", msg);
                                break;
                            case LAErrorTouchIDLockout:
                                // 多次指纹验证不成功, Touch ID 被锁定
                                msg = @"";
                                NSLog(@"Touch ID 被锁定");
                                // 这里我们并不需要调用系统密码输入, 所以这里不再再次调用
//                                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {}];
                                break;
                            default:
                                break;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            reply(success, error, msg);
                        });
                    }
                }];
            } else { // 系统方法验证, 设备是不支持 TouchID 的
                NSLog(@"模拟器, 不能使用 Touch ID");
            }
        } else { // 系统版本低于8.0
            // 弹框提示由于系统版本原因不能开启
            NSLog(@"系统版本低于8.0, 不能使用 Touch ID");
        }
    } else {
        isVarify ? NSLog(@"用户没有开启指纹验证") : NSLog(@"不可能发生的情况= =");
    }
}

@end
