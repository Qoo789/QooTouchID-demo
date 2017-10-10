//
//  QOOGestureVerifyVC.m
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#import "QOOGestureVerifyVC.h"
#import "QOOGestureSettingVC.h"
#import "PCCircleViewConst.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"

@interface QOOGestureVerifyVC ()<CircleViewDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

@end

@implementation QOOGestureVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"验证手势密码";
    
    [self.view setBackgroundColor:CircleViewBackgroundColor];
    
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {
    if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功");
            
            if (self.isToSetNewGesture) {
                QOOGestureSettingVC *settingVC = [[QOOGestureSettingVC alloc] init];
                [settingVC setType:GestureSettingVCTypeResetting];
                [self.navigationController pushViewController:settingVC animated:YES];
            } else {
                [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
                [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kFingerprintVerifyKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    }
}


@end
