//
//  HQQVRRenderer.m
//  Pods
//
//  Created by 黄强强 on 17/4/2.
//
//

#import "HQQVRRenderer.h"
#import "HQQVRTexture.h"
#import "HQQVRProgram.h"
#import "HQQVRSphereObject.h"

@interface HQQVRRenderer()
@property (nonatomic, strong) HQQVRTexture *texture;
@property (nonatomic, strong) HQQVRProgram *program;
@property (nonatomic, strong) HQQVRSphereObject *object3D;

@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, strong) AVPlayerItem *displayVideo;
@end

@implementation HQQVRRenderer

- (void)loadImage:(UIImage *)image
{
    self.displayImage = image;
}

- (void)loadVideo:(AVPlayerItem *)playerItem
{
    self.displayVideo = playerItem;
}

- (void)vrViewControllerDidReady
{
    self.program = [HQQVRProgram createProgram];
    self.texture = [[HQQVRTexture alloc] init];
    self.object3D = [HQQVRSphereObject objectWithProgram:self.program];
    
    if (self.displayImage) {
        [self.texture loadImage:self.displayImage];
    }
    else if (self.displayVideo) {
        [self.texture loadVideoWithPlayerItem:self.displayVideo];
    }
}


- (void)vrViewController:(EAGLContext *)context willDrawInRect:(CGRect)rect
{
    NSAssert(self.object3D != nil, @"3D Object is nil");
    NSAssert(self.texture != nil, @"Texture is nil");
    NSAssert(self.program != nil, @"Program is nil");
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    NSArray *directors = self.directorManager.directors;
    
    if (directors.count <= 0) return;
    
    [self.texture updateTexture:context];
    
    float size = [[UIScreen mainScreen] nativeScale];
    float width = [UIScreen mainScreen].bounds.size.width * size;
    float height = [UIScreen mainScreen].bounds.size.height * size;
    NSUInteger count = directors.count;
    for (int i = 0; i < count; i++) {
        HQQVRDirector *director = directors[i];
        
        float x = width / count * i;
        float y = 0;
        float w = width / count;
        float h = height;
        glViewport(x, y, w, h);
        
        [director updateProjectionMatrixWithWidth:w height:h];
//        [self.object3D updateVertex:self.program];
//        [self.object3D updateTexture:self.program];
        
        [director shot:self.program];
        [self.object3D draw];
    }
}

@end
