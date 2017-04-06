//
//  HQQM3U8VideoViewController.m
//  HQQVRPlayer
//
//  Created by 黄强强 on 17/4/1.
//  Copyright © 2017年 huangqiangqiang. All rights reserved.
//

#import "HQQM3U8VideoViewController.h"
#import <HQQVRPlayer/HQQVRPlayer.h>

@interface HQQM3U8VideoViewController ()
@property (nonatomic, strong) HQQVRPlayer *vrPlayer;
@end

@implementation HQQM3U8VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vrPlayer = [HQQVRPlayer player];
    self.vrPlayer.touchEnable = YES;
    self.vrPlayer.displayType = HQQVRDisplayTypePanorama;
    self.vrPlayer.interactiveType = HQQVRInteractiveTypeMotion;
    [self.vrPlayer loadVideo:[NSURL URLWithString:@"http://139.198.9.190/Public/stream/shuangtasi/stream.m3u8"]];
    [self.view addSubview:self.vrPlayer.view];
    [self.vrPlayer play];
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
