//
//  HQQVRViewController.h
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import <GLKit/GLKit.h>

@protocol HQQVRViewControllerDelegate <NSObject>
- (void)vrViewControllerDidReady;
- (void)vrViewController:(EAGLContext *)context willDrawInRect:(CGRect)rect;
@end

@interface HQQVRViewController : GLKViewController
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) NSInteger displayFramesPerSecond;
@property (nonatomic, weak) id<HQQVRViewControllerDelegate> vrDelegate;
@end
