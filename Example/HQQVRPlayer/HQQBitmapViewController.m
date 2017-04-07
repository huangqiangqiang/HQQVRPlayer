//
//  HQQBitmapViewController.m
//  HQQVRPlayer
//
//  Created by 黄强强 on 17/3/31.
//  Copyright © 2017年 huangqiangqiang. All rights reserved.
//

#import "HQQBitmapViewController.h"
#import <HQQVRPlayer/HQQVRPlayer.h>

@interface HQQBitmapViewController ()
@property (nonatomic, strong) HQQVRPlayer *vrPlayer;
@end

@implementation HQQBitmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vrPlayer = [HQQVRPlayer player];
    self.vrPlayer.touchEnable = YES;
    self.vrPlayer.displayType = HQQVRDisplayTypePanorama;
    self.vrPlayer.doubleTapToScaleEnable = YES;
    self.vrPlayer.interactiveType = HQQVRInteractiveTypeMotionAndTouch;
    [self.vrPlayer loadImage:[UIImage imageNamed:@"resource/testImage.png"]];
    [self.view addSubview:self.vrPlayer.view];
}

- (void)displayChanged:(int)index
{
    self.vrPlayer.displayType = index;
}

- (void)interactiveChanged:(int)index
{
    self.vrPlayer.interactiveType = index;
}

@end
