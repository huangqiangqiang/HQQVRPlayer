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



@end
