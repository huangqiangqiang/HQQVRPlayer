//
//  HQQNetworkBitmapViewController.m
//  HQQVRPlayer
//
//  Created by 黄强强 on 17/5/27.
//  Copyright © 2017年 huangqiangqiang. All rights reserved.
//

#import "HQQNetworkBitmapViewController.h"
#import <HQQVRPlayer/HQQVRPlayer.h>
#import <SDWebImage/SDWebImageManager.h>

@interface HQQNetworkBitmapViewController ()

@property (nonatomic, strong) HQQVRPlayer *vrPlayer;
@end

@implementation HQQNetworkBitmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vrPlayer = [HQQVRPlayer player];
    self.vrPlayer.touchEnable = YES;
    self.vrPlayer.displayType = HQQVRDisplayTypePanorama;
    self.vrPlayer.doubleTapToScaleEnable = YES;
    self.vrPlayer.interactiveType = HQQVRInteractiveTypeMotionAndTouch;
    [self.vrPlayer addToParanterContoller:self];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:@"http://img02.tooopen.com/images/20160316/tooopen_sy_156105468631.jpg"] options:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        NSLog(@"%@",image);
        [self.vrPlayer loadImage:image];
    }];
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
