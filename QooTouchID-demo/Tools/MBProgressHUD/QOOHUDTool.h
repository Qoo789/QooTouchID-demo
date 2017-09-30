//
//  QOOHUDTool.h
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define SHOWERRORHUD(_msg_) [QOOHUDTool showCustomViewWithText:_msg_ type:Type_Error inView:[UIApplication sharedApplication].keyWindow]
#define SHOWINFOHUD(_msg_) [QOOHUDTool showCustomViewWithText:_msg_ type:Type_Info inView:[UIApplication sharedApplication].keyWindow]
#define SHOWSUCCESSHUD(_msg_) [QOOHUDTool showCustomViewWithText:_msg_ type:Type_Success inView:[UIApplication sharedApplication].keyWindow]
#define SHOWTIMEOUTHUD [QOOHUDTool showCustomViewWithText:@"连接失败!" type:Type_Error inView:[UIApplication sharedApplication].keyWindow]

// 定义状态枚举
typedef enum {
    Type_Success,
    Type_Error,
    Type_Info,
} HUDCustomViewType;

@interface QOOHUDTool : NSObject

@property (nonatomic, strong) NSString *text;			// 文本
@property (nonatomic, strong) UIFont *textFont;		// 文本字体

// 自定义view
@property (nonatomic, strong) UIView *customView;	  // 自定义view  37x37尺寸
@property (nonatomic, assign) BOOL showTextOnly;	// 只显示文本

@property (nonatomic, assign) HUDCustomViewType type;

+(void)showTextOnly:(NSString *)text duration:(NSTimeInterval)sec inView:(UIView *)view;

+(void)showText:(NSString *)text duration:(NSTimeInterval)sec inView:(UIView *)view;

+(void)showCustomViewWithText:(NSString *)text type:(HUDCustomViewType)type inView:(UIView *)view;

+(void)show;

+(void)hiden;

+(void)showHUDWithText:(NSString *)text;

+(instancetype) shareInstance;

@end
