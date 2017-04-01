//
//  HQQVRTexture.h
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HQQVRTexture : NSObject

- (void)loadImage:(UIImage *)image;
- (void)loadVideoWithPlayerItem:(AVPlayerItem *)playerItem;

- (void)updateTexture:(EAGLContext *)context;
@end
