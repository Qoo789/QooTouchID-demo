//
//  QOOConstantsConfig.h
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#ifndef QOOConstantsConfig_h
#define QOOConstantsConfig_h

// 当前主窗口
#define kWindow [UIApplication sharedApplication].keyWindow

// 页面尺寸相关
// 主屏幕宽,高
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

// 比例系数
#define kWidthScale   kScreenWidth / 750
#define kHeightScale  kScreenHeight / 1334

// 本地化存储相关
// 是否开启指纹key
#define kFingerprintVerifyKey @"touchIDIsOn"
// 进入后台时间记录key
#define kEnterBackgroundTimeKey @"enterBackgroundTime"


#endif /* QOOConstantsConfig_h */
