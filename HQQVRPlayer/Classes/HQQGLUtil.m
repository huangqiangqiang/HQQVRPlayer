//
//  HQQGLUtil.m
//  Pods
//
//  Created by 黄强强 on 17/4/1.
//
//

#import "HQQGLUtil.h"

@implementation HQQGLUtil

+ (GLuint)createGPUProgramWithVertexShaderPath:(NSString *)v_path fragmentShaderPath:(NSString *)f_path
{
    GLuint v_shader = [self compileShader:GL_VERTEX_SHADER path:v_path];
    GLuint f_shader = [self compileShader:GL_FRAGMENT_SHADER path:f_path];
    
    NSAssert(v_shader != 0, @"vertex shader create failed;");
    NSAssert(f_shader != 0, @"fragment shader create failed;");
    
    GLuint programHandler = glCreateProgram();
    glAttachShader(programHandler, v_shader);
    glAttachShader(programHandler, f_shader);
    glLinkProgram(programHandler);
    
    GLint status = GL_FALSE;
    glGetProgramiv(programHandler, GL_LINK_STATUS, &status);
    if (status == GL_FALSE) {
        char info[1024] = {0};
        GLsizei len = 0;
        glGetProgramInfoLog(programHandler, 1024, &len, info);
        NSLog(@"Program Link Error:%s\n",info);
        glDeleteShader(v_shader);
        glDeleteShader(f_shader);
        glDeleteProgram(programHandler);
        return nil;
    }
    return programHandler;
}

+ (GLuint)compileShader:(GLenum)type path:(NSString *)path
{
    GLuint shader = glCreateShader(type);
    NSString *sourceStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    const char *sourceCode = [sourceStr UTF8String];
    /*
     把shader和源码绑定
     第二个参数指定了传递的源码字符串数量，这里是1个
     第三个参数是顶点着色器真正的源码
     第四个参数我们先设置为NULL
     */
    glShaderSource(shader, 1, &sourceCode, NULL);
    glCompileShader(shader);
    GLint status = GL_FALSE;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE) {
        char info[1024] = {0};
        GLsizei len = 0;
        glGetShaderInfoLog(shader, 1024, &len, info);
        NSLog(@"Shader Compile Error:%s\n",info);
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

+ (void)texImage2D:(UIImage *)image
{
    GLsizei width = CGImageGetWidth(image.CGImage);
    GLsizei height = CGImageGetHeight(image.CGImage);
    
    void *imageData = malloc(width * height * 4);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(imageData);
}




/** see {@link #remapCoordinateSystem} */
static const int AXIS_X = 1;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_Y = 2;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_MINUS_X = AXIS_X | 0x80;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_MINUS_Y = AXIS_Y | 0x80;

+ (GLKMatrix4)calculateMatrixFromQuaternion:(CMQuaternion*)quaternion orientation:(UIInterfaceOrientation) orientation
{
    GLKMatrix4 sensor = [self getRotationMatrixFromQuaternion:quaternion];
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeRight:
            sensor = [self remapCoordinateSystem:sensor.m X:AXIS_MINUS_Y Y:AXIS_X];
            break;
        case UIDeviceOrientationLandscapeLeft:
            sensor = [self remapCoordinateSystem:sensor.m X:AXIS_Y Y:AXIS_MINUS_X];
            break;
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown://not support now
        default:
            break;
    }
    return sensor;
}

+ (GLKMatrix4)getRotationMatrixFromQuaternion:(CMQuaternion*)quaternion{
    
    float q0 = quaternion->w;
    float q1 = quaternion->x;
    float q2 = quaternion->y;
    float q3 = quaternion->z;
    
    float sq_q1 = 2 * q1 * q1;
    float sq_q2 = 2 * q2 * q2;
    float sq_q3 = 2 * q3 * q3;
    float q1_q2 = 2 * q1 * q2;
    float q3_q0 = 2 * q3 * q0;
    float q1_q3 = 2 * q1 * q3;
    float q2_q0 = 2 * q2 * q0;
    float q2_q3 = 2 * q2 * q3;
    float q1_q0 = 2 * q1 * q0;
    
    float r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;
    r0 = 1 - sq_q2 - sq_q3;
    r1 = q1_q2 - q3_q0;
    r2 = q1_q3 + q2_q0;
    r3 = 0.0f;
    
    r4 = q1_q2 + q3_q0;
    r5 = 1 - sq_q1 - sq_q3;
    r6 = q2_q3 - q1_q0;
    r7 = 0.0f;
    
    r8 = q1_q3 - q2_q0;
    r9 = q2_q3 + q1_q0;
    r10 = 1 - sq_q1 - sq_q2;
    r11 = 0.0f;
    
    r12 = r13 = r14 = 0.0f;
    r15 = 1.0f;
    
    return GLKMatrix4Make(r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15);
}

+(GLKMatrix4) remapCoordinateSystem:(float*)inR X:(int)X Y:(int)Y{
    return [self remapCoordinateSystemImpl:inR X:X Y:Y];
}

+(GLKMatrix4) remapCoordinateSystemImpl:(float*)inR X:(int)X Y:(int)Y {
    /*
     * X and Y define a rotation matrix 'r':
     *
     *  (X==1)?((X&0x80)?-1:1):0    (X==2)?((X&0x80)?-1:1):0    (X==3)?((X&0x80)?-1:1):0
     *  (Y==1)?((Y&0x80)?-1:1):0    (Y==2)?((Y&0x80)?-1:1):0    (Y==3)?((X&0x80)?-1:1):0
     *                              r[0] ^ r[1]
     *
     * where the 3rd line is the vector product of the first 2 lines
     *
     */
    GLKMatrix4 outMatrix4 = GLKMatrix4Identity;
    
    if ((X & 0x7C)!=0 || (Y & 0x7C)!=0)
        return outMatrix4;   // invalid parameter
    if (((X & 0x3)==0) || ((Y & 0x3)==0))
        return outMatrix4;   // no axis specified
    if ((X & 0x3) == (Y & 0x3))
        return outMatrix4;   // same axis specified
    
    // Z is "the other" axis, its sign is either +/- sign(X)*sign(Y)
    // this can be calculated by exclusive-or'ing X and Y; except for
    // the sign inversion (+/-) which is calculated below.
    int Z = X ^ Y;
    
    // extract the axis (remove the sign), offset in the range 0 to 2.
    const int x = (X & 0x3)-1;
    const int y = (Y & 0x3)-1;
    const int z = (Z & 0x3)-1;
    
    // compute the sign of Z (whether it needs to be inverted)
    const int axis_y = (z+1)%3;
    const int axis_z = (z+2)%3;
    if (((x^axis_y)|(y^axis_z)) != 0)
        Z ^= 0x80;
    
    const Boolean sx = (X>=0x80);
    const Boolean sy = (Y>=0x80);
    const Boolean sz = (Z>=0x80);
    
    float* outR = malloc(sizeof(float) * 16);
    
    // Perform R * r, in avoiding actual muls and adds.
    const int rowLength = 4; // 4 * 4
    for (int j=0 ; j<3 ; j++) {
        const int offset = j*rowLength;
        for (int i=0 ; i<3 ; i++) {
            if (x==i)   outR[offset+i] = sx ? -inR[offset+0] : inR[offset+0];
            if (y==i)   outR[offset+i] = sy ? -inR[offset+1] : inR[offset+1];
            if (z==i)   outR[offset+i] = sz ? -inR[offset+2] : inR[offset+2];
        }
    }
    
    outR[3] = outR[7] = outR[11] = outR[12] = outR[13] = outR[14] = 0;
    outR[15] = 1;
    outMatrix4 = GLKMatrix4MakeWithArray(outR);
    free(outR);
    return outMatrix4;
    
}

@end
