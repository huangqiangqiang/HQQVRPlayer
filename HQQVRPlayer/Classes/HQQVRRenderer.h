//
//  HQQVRRenderer.h
//  Pods
//
//  Created by 黄强强 on 17/4/2.
//
//

#import <Foundation/Foundation.h>
#import "HQQVRDirectorManager.h"
#import <AVFoundation/AVFoundation.h>
#import "HQQVRViewController.h"

@interface HQQVRRenderer : NSObject <HQQVRViewControllerDelegate>
- (void)loadImage:(UIImage *)image;
- (void)loadVideo:(AVPlayerItem *)video;
@property (nonatomic, strong) HQQVRDirectorManager *directorManager;
@end
