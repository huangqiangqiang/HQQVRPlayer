//
//  HQQVRDirector.h
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import <GLKit/GLKit.h>
#import "HQQVRProgram.h"

@interface HQQVRDirector : NSObject

- (void)setEyeX:(float)eyeX;
- (void)setLookX:(float)lookX;

- (void)updateTouchX:(float)offsetX touchY:(float)offsetY;

- (void)updateProjectionMatrixWithWidth:(float)width height:(float)height;

- (void)shot:(HQQVRProgram *)program;

- (void)updateSensorMatrix:(GLKMatrix4)sensorMatrix;

@end
