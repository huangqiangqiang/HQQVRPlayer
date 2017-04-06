//
//  HQQVRPlayer.h
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, HQQVRDisplayType) {
    HQQVRDisplayTypePanorama = 0,
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
@property (nonatomic, assign) HQQVRDisplayType displayType;
@property (nonatomic, assign) HQQVRInteractiveType interactiveType;

/**
 帧数：30~60之间，如果超过这个范围取30或60
 */
@property (nonatomic, assign) NSInteger displayFramesPerSecond;

#pragma mark - image api

- (void)loadImage:(UIImage *)image;

#pragma mark - video api

- (void)loadVideo:(NSURL *)url;

/**
 此方法只对视频资源有效
 */
- (void)play;

/**
 此方法只对视频资源有效
 */
- (void)pause;

/**
 播放进度更新，block 1秒钟调一次
 此方法只对视频资源有效

 @param currentTime 当前视频播放时间
 @param duration    视频总时间
 */
- (void)setVideoPlayTimeUpdateHandler:(void (^)(float current, float duration, CMTime currentTime, CMTime durationTime))handler;

/**
 此方法只对视频资源有效
 */
- (void)seekToTimeWithFloat:(float)time;
- (void)seekToTime:(CMTime)time;

@end
