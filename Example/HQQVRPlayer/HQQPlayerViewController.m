//
//  HQQPlayerViewController.m
//  HQQVRPlayer
//
//  Created by 黄强强 on 17/4/2.
//  Copyright © 2017年 huangqiangqiang. All rights reserved.
//

#import "HQQPlayerViewController.h"

@interface HQQPlayerViewController ()
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *displayBtn;
@property (nonatomic, strong) UIButton *interactiveBtn;
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
    
    self.displayBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.displayBtn.contentMode = UIViewContentModeCenter;
    self.displayBtn.frame = CGRectMake(64, 10, 60, 44);
    [self.displayBtn setTitle:@"Display" forState:UIControlStateNormal];
    [self.displayBtn addTarget:self action:@selector(diaplayChanged) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.displayBtn];
    
    self.interactiveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.interactiveBtn.contentMode = UIViewContentModeCenter;
    self.interactiveBtn.frame = CGRectMake(134, 10, 80, 44);
    [self.interactiveBtn setTitle:@"Interactive" forState:UIControlStateNormal];
    [self.interactiveBtn addTarget:self action:@selector(interactiveChanged) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.interactiveBtn];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)diaplayChanged
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Display" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *pAction = [UIAlertAction actionWithTitle:@"Panorama" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayChanged:0];
    }];
    UIAlertAction *vrAction = [UIAlertAction actionWithTitle:@"VR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayChanged:1];
    }];
    [alert addAction:pAction];
    [alert addAction:vrAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)interactiveChanged
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Interactive" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Motion" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self interactiveChanged:0];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Touch" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self interactiveChanged:1];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Touch And Sensor" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self interactiveChanged:2];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)interactiveChanged:(int)index {}
- (void)displayChanged:(int)index {}

@end
