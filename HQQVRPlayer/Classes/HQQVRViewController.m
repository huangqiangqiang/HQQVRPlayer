//
//  HQQVRViewController.m
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import "HQQVRViewController.h"

@interface HQQVRViewController ()
@end

@implementation HQQVRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!self.context) {
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    NSAssert(self.context != nil, @"[HQQVRPlayer] EAGLContext is nil.");
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.vrDelegate vrViewControllerDidReady];
}

- (void)setDisplayFramesPerSecond:(NSInteger)displayFramesPerSecond
{
    displayFramesPerSecond = MIN(60, MAX(displayFramesPerSecond, 30));
    [self setPreferredFramesPerSecond:displayFramesPerSecond];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.vrDelegate vrViewController:self.context willDrawInRect:rect];
}

- (void)dealloc
{
    NSLog(@"%@ ------ dealloc",self.class);
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
}

@end
