//
//  HQQPlayerViewController.m
//  HQQVRPlayer
//
//  Created by 黄强强 on 17/4/2.
//  Copyright © 2017年 huangqiangqiang. All rights reserved.
//

#import "HQQPlayerViewController.h"

@interface HQQPlayerViewController ()
@end

@implementation HQQPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupUI];
}

- (void)setupUI
{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.contentMode = UIViewContentModeCenter;
    self.backBtn.frame = CGRectMake(10, 10, 44, 44);
    [self.backBtn setImage:[UIImage imageNamed:@"resource/back_icon@2x"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
