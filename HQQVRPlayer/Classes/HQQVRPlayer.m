//
//  HQQVRPlayer.m
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import "HQQVRPlayer.h"
#import "HQQVRViewController.h"
#import "HQQVRTexture.h"
#import <AVFoundation/AVFoundation.h>
#import "HQQVRProgram.h"
#import "HQQVRDirectorManager.h"
#import "HQQVRObject3DProtocol.h"
#import "HQQVRSphereObject.h"

@interface HQQVRPlayer() <HQQVRViewControllerDelegate>

@property (nonatomic, strong) HQQVRViewController *controller;

@property (nonatomic, strong) HQQVRTexture *texture;
@property (nonatomic, strong) HQQVRProgram *program;
@property (nonatomic, strong) HQQVRDirectorManager *directorManager;
@property (nonatomic, strong) id<HQQVRObject3DProtocol> object3D;

@property (nonatomic, assign, getter=isImageSource) BOOL imageSource;
@property (nonatomic, strong) id originSource;
@property (nonatomic, strong) AVPlayer *videoPlayer;

@property (nonatomic, assign) CGPoint prevPoint;
@end

@implementation HQQVRPlayer

+ (instancetype)player
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.controller = [[HQQVRViewController alloc] init];
        self.controller.vrDelegate = self;
        [self.controller.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerOnPan:)]];
    }
    return self;
}

- (void)setDisplayFramesPerSecond:(NSInteger)displayFramesPerSecond
{
    self.controller.displayFramesPerSecond = displayFramesPerSecond;
}

- (void)setDisplayType:(HQQVRDisplayType)displayType
{
    _displayType = displayType;
}

- (void)setRenderShape:(HQQVRRenderShape)renderShape
{
    _renderShape = renderShape;
}

- (UIView *)view
{
    return self.controller.view;
}

- (void)loadImage:(UIImage *)image
{
    self.imageSource = YES;
    if (self.texture) {
        [self.texture loadImage:image];
    }
    else{
        self.originSource = image;
    }
}

- (void)loadVideo:(NSURL *)url
{
    self.imageSource = NO;
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    self.videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    if (self.texture) {
        [self.texture loadVideoWithPlayerItem:playerItem];
        [self.videoPlayer play];
    }
    else{
        self.originSource = playerItem;
    }
}

- (void)dealloc
{
    NSLog(@"%@ ------ dealloc",self.class);
}

- (void)loadObject3D:(HQQVRRenderShape)shape
{
    switch (shape) {
        case HQQVRRenderShapeSphere:
            self.object3D = [[HQQVRSphereObject alloc] init];
            break;
    }
    
    [self.object3D createObject3D];
}

#pragma mark - <UIGestureRecognizer>

- (void)gestureRecognizerOnPan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.prevPoint = point;
    }
    float offsetX = self.prevPoint.x - point.x;
    float offsetY = self.prevPoint.y - point.y;
    for (HQQVRDirector *director in self.directorManager.directors) {
        [director updateTouchX:offsetX*0.2 touchY:offsetY*0.2];
    }
    self.prevPoint = point;
}

#pragma mark - <HQQVRViewControllerDelegate>

- (void)vrViewControllerDidReady
{
    self.program = [HQQVRProgram createProgram];
    self.texture = [[HQQVRTexture alloc] init];
    self.directorManager = [HQQVRDirectorManager manager];
    self.directorManager.displayType = self.displayType;
    [self loadObject3D:HQQVRRenderShapeSphere];
    
    if (self.originSource) {
        if (self.isImageSource) {
            [self.texture loadImage:(UIImage *)self.originSource];
        }
        else{
            AVPlayerItem *item = (AVPlayerItem *)self.originSource;
            [self.texture loadVideoWithPlayerItem:item];
            [self.videoPlayer play];
        }
        self.originSource = nil;
    }
}


- (void)vrViewController:(EAGLContext *)context willDrawInRect:(CGRect)rect
{
    NSAssert(self.object3D != nil, @"3D Object is nil");
    NSAssert(self.texture != nil, @"Texture is nil");
    NSAssert(self.program != nil, @"Program is nil");
    
    glClearColor(0.1, 0.1, 0.1, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    NSArray *directors = self.directorManager.directors;
    
    if (directors.count <= 0) {
        return;
    }
    
    if (!self.isImageSource) {
        [self.texture updateTexture:context];
    }
    
    float size = [[UIScreen mainScreen] nativeScale];
    float width = [UIScreen mainScreen].bounds.size.width * size;
    float height = [UIScreen mainScreen].bounds.size.height * size;
    for (int i = 0; i < directors.count; i++) {
        HQQVRDirector *director = directors[i];
        glViewport(width * i, 0, width, height);
        [director updateProjectionMatrixWithWidth:width height:height];
        [director shot:self.program];
    }
    [self.object3D updateVertex:self.program];
    [self.object3D updateTexture:self.program];
    
    [self.object3D draw];
}

@end
