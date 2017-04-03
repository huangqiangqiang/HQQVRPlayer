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
#import "HQQVRSphereObject.h"
#import "HQQVRRenderer.h"

@interface HQQVRPlayer()

@property (nonatomic, strong) HQQVRViewController *controller;

@property (nonatomic, strong) HQQVRTexture *texture;
@property (nonatomic, strong) HQQVRProgram *program;
@property (nonatomic, strong) HQQVRRenderer *renderer;
@property (nonatomic, strong) HQQVRDirectorManager *directorManager;
@property (nonatomic, strong) HQQVRSphereObject *object3D;

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
        self.directorManager = [[HQQVRDirectorManager alloc] init];
        self.renderer = [[HQQVRRenderer alloc] init];
        self.renderer.directorManager = self.directorManager;
        self.controller = [[HQQVRViewController alloc] init];
        self.controller.vrDelegate = self.renderer;
        
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
    self.directorManager.displayType = self.displayType;
}

- (void)setInteractiveType:(HQQVRInteractiveType)interactiveType
{
    _interactiveType = interactiveType;
    self.directorManager.interactiveType = self.interactiveType;
}

- (UIView *)view
{
    return self.controller.view;
}

- (void)loadImage:(UIImage *)image
{
    [self.renderer loadImage:image];
}

- (void)loadVideo:(NSURL *)url
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    self.videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    [self.videoPlayer play];
    [self.renderer loadVideo:playerItem];
    
}

- (void)dealloc
{
    NSLog(@"%@ ------ dealloc",self.class);
}

#pragma mark - <UIGestureRecognizer>

- (void)gestureRecognizerOnPan:(UIPanGestureRecognizer *)pan
{
    if (self.interactiveType == HQQVRInteractiveTypeMotion) {
        return;
    }
    
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

@end
