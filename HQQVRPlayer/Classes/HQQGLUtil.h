//
//  HQQGLUtil.h
//  Pods
//
//  Created by 黄强强 on 17/4/1.
//
//

#import <GLKit/GLKit.h>

@interface HQQGLUtil : NSObject
+ (GLuint)createGPUProgramWithVertexShaderPath:(NSString *)v_path fragmentShaderPath:(NSString *)f_path;

+ (void)texImage2D:(UIImage *)image;
@end
