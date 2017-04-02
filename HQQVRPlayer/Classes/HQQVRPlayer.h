//
//  HQQVRPlayer.h
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HQQVRDisplayType) {
    HQQVRDisplayTypeNone = 0,
    HQQVRDisplayTypePanorama,
    HQQVRDisplayTypeVR
};

typedef NS_ENUM(NSInteger, HQQVRInteractiveType) {
    HQQVRInteractiveTypeMotion = 0,
    HQQVRInteractiveTypeTouch,
    HQQVRInteractiveTypeMotionAndTouch
};

@interface HQQVRPlayer : NSObject

/**
 初始化方法
 */
+ (instancetype)player;

@property (nonatomic, weak, readonly) UIView *view;

@property (nonatomic, assign, getter=isTouchEnable) BOOL touchEnable;
@property (nonatomic, assign, getter=isControlEnable) BOOL controlEnable;
@property (nonatomic, assign) HQQVRDisplayType displayType;
@property (nonatomic, assign) HQQVRInteractiveType interactiveType;

- (void)loadImage:(UIImage *)image;
- (void)loadVideo:(NSURL *)url;

/**
 帧数：30~60之间，如果超过这个范围取30或60
 */
@property (nonatomic, assign) NSInteger displayFramesPerSecond;
@end
