//
//  QOOGestureSettingVC.h
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    GestureSettingVCTypeSetting = 1,
    GestureSettingVCTypeResetting,
    GestureSettingVCTypeLogin,
    GestureSettingVCTypeEnterForeground
}GestureSettingVCType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
}buttonTag;

@interface QOOGestureSettingVC : UIViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureSettingVCType type;

@end
