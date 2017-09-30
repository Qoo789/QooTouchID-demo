//
//  QOOTouchIDTool.h
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FingerprintVerifyTypeSetting = 1,
    FingerprintVerifyTypeVarify
}FingerprintVerifyType;

@interface QOOTouchIDTool : NSObject

// 当前控制器
+ (UIViewController *_Nullable)visibleController;

// 指纹验证方法
+ (void)fingerprintVerifyWithType:(FingerprintVerifyType)type andReply:(void(^_Nullable)(BOOL success, NSError * __nullable error, NSString *msg))reply;

@end
