//
//  HQQVRDirectorManager.m
//  Pods
//
//  Created by 黄强强 on 17/4/1.
//
//

#import "HQQVRDirectorManager.h"
#import <CoreMotion/CoreMotion.h>
#import "HQQGLUtil.h"

@interface HQQVRDirectorManager()

@property (nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation HQQVRDirectorManager

- (void)setDisplayType:(HQQVRDisplayType)displayType
{
    [self.directors removeAllObjects];
    
    if (displayType == HQQVRDisplayTypeVR) {
        HQQVRDirector *directorLeft = [[HQQVRDirector alloc] init];
        HQQVRDirector *directorRight = [[HQQVRDirector alloc] init];
        [self.directors addObject:directorLeft];
        [self.directors addObject:directorRight];
    }
    else if (displayType == HQQVRDisplayTypePanorama) {
        HQQVRDirector *director = [[HQQVRDirector alloc] init];
        [self.directors addObject:director];
    }
}

- (void)setInteractiveType:(HQQVRInteractiveType)interactiveType
{
    if (interactiveType == HQQVRInteractiveTypeMotion) {
        [self startMotion];
    }
    else if (interactiveType == HQQVRInteractiveTypeTouch) {
        [self stopMotion];
    }
    else if (interactiveType == HQQVRInteractiveTypeMotionAndTouch) {
        [self startMotion];
    }
}

- (NSMutableArray *)directors
{
    if (!_directors) {
        _directors = [NSMutableArray array];
    }
    return _directors;
}


- (void)startMotion
{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1.0 / 30.0;
    self.motionManager.gyroUpdateInterval = 1.0f / 30;
    self.motionManager.showsDeviceMovementDisplay = YES;
    [self.motionManager setDeviceMotionUpdateInterval:1.0f / 30.0];
    NSOperationQueue* motionQueue = [[NSOperationQueue alloc] init];
    
    [self.motionManager startDeviceMotionUpdatesToQueue:motionQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        
        CMAttitude* attitude = motion.attitude;
        if (attitude == nil) return;
        
        GLKMatrix4 sensor = GLKMatrix4Identity;
        CMQuaternion quaternion = attitude.quaternion;
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        sensor = [HQQGLUtil calculateMatrixFromQuaternion:&quaternion orientation:orientation];
        sensor = GLKMatrix4RotateX(sensor, M_PI_2);
        for (HQQVRDirector *director in self.directors) {
            [director updateSensorMatrix:sensor];
        }
    }];
}

- (void)stopMotion
{
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}

@end
