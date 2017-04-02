//
//  HQQGLUtil.h
//  Pods
//
//  Created by 黄强强 on 17/4/1.
//
//

#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>

@interface HQQGLUtil : NSObject
+ (GLuint)createGPUProgramWithVertexShaderPath:(NSString *)v_path fragmentShaderPath:(NSString *)f_path;

+ (GLKMatrix4)calculateMatrixFromQuaternion:(CMQuaternion*)quaternion orientation:(UIInterfaceOrientation)orientation;

+ (void)texImage2D:(UIImage *)image;
@end
