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
@property (nonatomic, assign) float lookY;

@property (nonatomic, assign) float targetX;
@property (nonatomic, assign) float targetY;

@property (nonatomic, assign) float touchX;
@property (nonatomic, assign) float touchY;

@property (nonatomic, assign) float nearScale;
@property (nonatomic, assign) int pointOfViewAnimationCountdown;

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
        self.lookY = 0.0f;
        self.nearScale = 1.0f;
        
        self.sensorMatrix = GLKMatrix4Identity;
        self.modelMatrix = GLKMatrix4Identity;
        self.viewMatrix = GLKMatrix4Identity;
        
        [self setupViewMatrix];
    }
    return self;
}

- (void)setEyeX:(float)eyeX
{
    _eyeX = eyeX;
    [self setupViewMatrix];
}

- (void)setLookX:(float)lookX
{
    _lookX = lookX;
    [self setupViewMatrix];
}

- (void)setupViewMatrix
{
    float eyeX = self.eyeX;
    float eyeY = 0.0f;
    float eyeZ = 0.0f;
    float lookX = self.lookX;
    float lookY = self.lookY;
    float lookZ = -1.0f;
    float upX = 0.0f;
    float upY = 1.0f;
    float upZ = 0.0f;
    self.viewMatrix = GLKMatrix4MakeLookAt(eyeX, eyeY, eyeZ, lookX, lookY, lookZ, upX, upY, upZ);
}

- (void)updateProjectionMatrixWithWidth:(float)width height:(float)height
{
    float ratio = width / height;
    self.projectionMatrix = GLKMatrix4MakeFrustum(-0.5 * ratio, 0.5 * ratio, -0.5, 0.5, [self getNear], 100.0);
}

- (float)getNear
{
    return 0.7 * _nearScale;
}

- (void)shot:(HQQVRProgram *)program
{
    if (self.pointOfViewAnimationCountdown > 0) {
        self.pointOfViewAnimationCountdown--;
        self.lookX = [self lowPassFilter:self.lookX target:self.targetX];
        self.lookY = [self lowPassFilter:self.lookY target:self.targetY];
        self.nearScale = [self lowPassFilter:self.nearScale target:1.5];
        [self setupViewMatrix];
    }
    
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

- (void)lookAndScaleAtPoint:(CGPoint)point
{
    if (self.nearScale == 1.0f) {
        self.pointOfViewAnimationCountdown = 10;
        float screenW = [UIScreen mainScreen].bounds.size.width;
        float screenH = [UIScreen mainScreen].bounds.size.height;
        self.targetX = (point.x - screenW / 2) / (screenW / 2);
        self.targetY = (screenH / 2 - point.y) / (screenH / 2);
    }
    else{
        self.nearScale = 1.0f;
        self.lookX = 0.0f;
        self.lookY = 0.0f;
    }
}

- (float)lowPassFilter:(float)current target:(float)target
{
    return current + (4.0 * 0.03 * (target - current));
}

- (void)dealloc
{
    NSLog(@"%@ ------ dealloc",self.class);
}

@end
