//
//  QOOUnlockSettingVC.m
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#import "QOOUnlockSettingVC.h"
#import "QOOGestureVerifyVC.h"
#import "QOOGestureSettingVC.h"
#import "QOOTouchIDTool.h"
#import "PCCircleViewConst.h"

@interface QOOUnlockSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UISwitch *gestureSwitch;
@property (nonatomic, strong)UISwitch *touchidSwitch;
@property (nonatomic, assign, getter = isTouchIDLocked)BOOL touchIDLocked;

@end

@implementation QOOUnlockSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手势、指纹解锁设置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *t = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    t.delegate = self;
    t.dataSource = self;
    [self.view addSubview:t];
    self.tableView = t;
    
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

#pragma mark - Action
- (void)gestureSwitchChanged:(UISwitch *)sender {
    UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *cell2;
    
    if (sender.isOn) {
        
        cell1.userInteractionEnabled = YES;
        cell1.textLabel.textColor = [UIColor blackColor];
        
        if (!self.isTouchIDLocked) {
            cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            
            self.touchidSwitch.userInteractionEnabled = YES;
            
            cell2.userInteractionEnabled = YES;
            cell2.textLabel.textColor = [UIColor blackColor];
        }
        
        QOOGestureSettingVC *vc = [[QOOGestureSettingVC alloc] init];
        vc.type = GestureSettingVCTypeSetting;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        cell1.userInteractionEnabled = NO;
        cell1.textLabel.textColor = [UIColor lightGrayColor];
        
        if (!self.isTouchIDLocked) {
            cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            
            self.touchidSwitch.userInteractionEnabled = NO;
            self.touchidSwitch.on = NO;
            
            cell2.userInteractionEnabled = NO;
            cell2.textLabel.textColor = [UIColor lightGrayColor];
        }
        
        // 不管指纹有没有被锁定, 关闭手势密码都必须清除指纹
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kFingerprintVerifyKey];
        
        // 先验证, 再清空手势
        QOOGestureVerifyVC *vc = [[QOOGestureVerifyVC alloc] init];
        vc.isToSetNewGesture = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)touchidSwitchChanged:(UISwitch *)sender {
    if (sender.isOn) { // 开启指纹
        [QOOTouchIDTool fingerprintVerifyWithType:FingerprintVerifyTypeSetting andReply:^(BOOL success, NSError * _Nullable error, NSString *msg) {
            if (success) {
                // 保存指纹验证开启状态
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFingerprintVerifyKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSLog(@"指纹解锁开启成功");
                SHOWSUCCESSHUD(@"指纹解锁开启成功");
//                [QOOHUDTool showTextOnly:@"指纹解锁开启成功" duration:1 inView:kWindow];
            } else {
                sender.on = !sender.isOn;
                if ([msg isEqualToString:@""]) {
                    SHOWERRORHUD(@"指纹解锁开启失败");
                } else {
                    SHOWERRORHUD(msg);
                }
//                [QOOHUDTool showTextOnly:@"指纹解锁开启失败" duration:1 inView:kWindow];
            }
        }];
    } else { // 关闭指纹
        [QOOTouchIDTool fingerprintVerifyWithType:FingerprintVerifyTypeVarify andReply:^(BOOL success, NSError * _Nullable error, NSString *msg) {
            if (success) {
                // 保存指纹验证关闭状态
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kFingerprintVerifyKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSLog(@"指纹解锁关闭成功");
                SHOWSUCCESSHUD(@"指纹解锁关闭成功");
//                [QOOHUDTool showTextOnly:@"指纹解锁关闭成功" duration:1 inView:kWindow];
            } else {
                sender.on = !sender.isOn;
                SHOWERRORHUD(@"指纹解锁关闭失败");
//                [QOOHUDTool showTextOnly:@"指纹解锁关闭失败" duration:1 inView:kWindow];
            }
        }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"开启手势解锁";
        UISwitch *sw = [[UISwitch alloc] init];
        cell.accessoryView = sw;
        self.gestureSwitch = sw;
        
        if ([PCCircleViewConst getGestureWithKey:gestureFinalSaveKey]) { // 当前已经设置了手势密码
            sw.on = YES;
        } else { // 没有设置或者关闭了 TouchID
            sw.on = NO;
        }
        
        [sw addTarget:self action:@selector(gestureSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"修改手势密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!self.gestureSwitch.isOn) {
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        } else {
            cell.userInteractionEnabled = YES;
            cell.textLabel.textColor = [UIColor blackColor];
        }
    } else {
        cell.textLabel.text = @"开启指纹解锁";
        UISwitch *sw = [[UISwitch alloc] init];
        cell.accessoryView = sw;
        self.touchidSwitch = sw;
        [sw addTarget:self action:@selector(touchidSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        if (!self.gestureSwitch.isOn) {
            sw.on = NO;
            sw.userInteractionEnabled = NO;
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        } else {
            sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:kFingerprintVerifyKey];
            sw.userInteractionEnabled = YES;
            cell.userInteractionEnabled = YES;
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        // 先验证, 再设置
        QOOGestureVerifyVC *vc = [[QOOGestureVerifyVC alloc] init];
        vc.isToSetNewGesture = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}









@end
