//
//  HQQVRDirector.m
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import "HQQVRDirector.h"

@interface HQQVRDirector()
@property (nonatomic, assign) float eyeX;
@property (nonatomic, assign) float lookX;

@property (nonatomic, assign) float touchX;
@property (nonatomic, assign) float touchY;

@property (nonatomic, assign) GLKMatrix4 sensorMatrix;

@property (nonatomic, assign) GLKMatrix4 modelMatrix;
@property (nonatomic, assign) GLKMatrix4 viewMatrix;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
@end

@implementation HQQVRDirector

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.eyeX = 0.0f;
        self.lookX = 0.0f;
        
        self.sensorMatrix = GLKMatrix4Identity;
        self.modelMatrix = GLKMatrix4Identity;
        self.viewMatrix = GLKMatrix4Identity;
        
        [self setupViewMatrix];
    }
    return self;
}

- (void)setupViewMatrix
{
    float eyeX = self.eyeX;
    float eyeY = 0.0f;
    float eyeZ = 0.0f;
    float lookX = self.lookX;
    float lookY = 0.0f;
    float lookZ = -1.0f;
    float upX = 0.0f;
    float upY = 1.0f;
    float upZ = 0.0f;
    self.viewMatrix = GLKMatrix4MakeLookAt(eyeX, eyeY, eyeZ, lookX, lookY, lookZ, upX, upY, upZ);
}

- (void)updateProjectionMatrixWithWidth:(float)width height:(float)height
{
    float ratio = width / height;
    self.projectionMatrix = GLKMatrix4MakeFrustum(-0.5 * ratio, 0.5 * ratio, -0.5, 0.5, 0.7, 100.0);
}

- (void)shot:(HQQVRProgram *)program
{
    self.modelMatrix = GLKMatrix4Identity;
    self.modelMatrix = GLKMatrix4Rotate(self.modelMatrix, GLKMathDegreesToRadians(self.touchY), 1.0, 0.0, 0.0);
    self.modelMatrix = GLKMatrix4Rotate(self.modelMatrix, GLKMathDegreesToRadians(self.touchX), 0.0, 1.0, 0.0);
    self.modelMatrix = GLKMatrix4Multiply(self.sensorMatrix, self.modelMatrix);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix);
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, modelViewMatrix);
    glUniformMatrix4fv(program.MVPMatrixHandler, 1, GL_FALSE, modelViewProjectionMatrix.m);
}

- (void)updateTouchX:(float)offsetX touchY:(float)offsetY
{
    _touchX += offsetX;
    _touchY += offsetY;
}

- (void)updateSensorMatrix:(GLKMatrix4)sensorMatrix
{
    self.sensorMatrix = sensorMatrix;
}


@end
