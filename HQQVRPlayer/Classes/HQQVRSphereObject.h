//
//  HQQVRSphereObject.h
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import <GLKit/GLKit.h>
#import "HQQVRProgram.h"

@interface HQQVRSphereObject : NSObject

+ (instancetype)objectWithProgram:(HQQVRProgram *)program;

- (void)draw;

@end
