//
//  ViewController.m
//  QooTouchID-demo
//
//  Created by pincai on 2017/9/30.
//  Copyright © 2017年 Qoo. All rights reserved.
//

#import "ViewController.h"
#import "QOOUnlockSettingVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"主页面";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *settingBtn = [[UIButton alloc] init];
    settingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [settingBtn setTitle:@"设置手势、指纹密码" forState: UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [settingBtn sizeToFit];
    settingBtn.frame = CGRectMake(0, 0, settingBtn.bounds.size.width + 20, settingBtn.bounds.size.height + 20);
    settingBtn.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    settingBtn.layer.borderWidth = 1;
    settingBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    settingBtn.layer.cornerRadius = 5;
    settingBtn.layer.masksToBounds = YES;
    [settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)settingBtnClicked:(UIButton *)sender {
    QOOUnlockSettingVC *vc = [[QOOUnlockSettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
