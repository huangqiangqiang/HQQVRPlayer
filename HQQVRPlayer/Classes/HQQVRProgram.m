//
//  HQQVRProgram.m
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import "HQQVRProgram.h"
#import <GLKit/GLKit.h>
#import "NSBundle+HQQVRPlayer.h"
#import "HQQGLUtil.h"

@interface HQQVRProgram()
@property (nonatomic, assign) GLuint programHandler;
@end

@implementation HQQVRProgram

+ (instancetype)createProgram
{
    HQQVRProgram *program = [[HQQVRProgram alloc] init];
    
    NSString *vsPath = [NSBundle hqq_vertexShaderPath];
    NSString *fsPath = [NSBundle hqq_fragmentShaderPath];
    program.programHandler = [HQQGLUtil createGPUProgramWithVertexShaderPath:vsPath fragmentShaderPath:fsPath];
    
    program.a_PositionHandler = glGetAttribLocation(program.programHandler, "a_Position");
    program.a_TexCoordHandler = glGetAttribLocation(program.programHandler, "a_TexCoord");
    program.u_TextureHandler = glGetUniformLocation(program.programHandler, "u_Texture");
    program.MVPMatrixHandler = glGetUniformLocation(program.programHandler, "MVPMatrix");
    
    glUseProgram(program.programHandler);
    return program;
}

@end
