//
//  HQQVRTexture.m
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import "HQQVRTexture.h"
#import "HQQGLUtil.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>


static void *VideoPlayer_PlayerItemStatusContext = &VideoPlayer_PlayerItemStatusContext;

@interface HQQVRTexture()
@property (nonatomic, assign) GLuint textureID;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerItemVideoOutput *output;
@property (nonatomic, assign) CVOpenGLESTextureCacheRef ref;
@end

@implementation HQQVRTexture

- (instancetype)init
{
    self = [super init];
    if (self) {
        glGenTextures(1, &_textureID);
    }
    return self;
}

- (void)loadImage:(UIImage *)image
{
    glBindTexture(GL_TEXTURE_2D, self.textureID);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    [HQQGLUtil texImage2D:image];
}

- (void)loadVideoWithPlayerItem:(AVPlayerItem *)playerItem
{
    
    self.playerItem = playerItem;
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:VideoPlayer_PlayerItemStatusContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == VideoPlayer_PlayerItemStatusContext) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay && self.output == nil) {
            NSDictionary *pixBufferAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
            self.output = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBufferAttributes];
            [self.playerItem addOutput:self.output];
        }
    }
}

- (void)updateTexture:(EAGLContext *)context
{
    if (self.playerItem == nil) {
        return;
    }
    CVPixelBufferRef pixelBuffer = NULL;
    CMTime currentTime = [self.playerItem currentTime];
    if ([self.output hasNewPixelBufferForItemTime:currentTime]) {
        pixelBuffer = [self.output copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
    }
    
    if (pixelBuffer == NULL) {
        return;
    }
    
    int bufferWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
    int bufferHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    if (_ref == NULL) {
        CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, context, NULL, &_ref);
    }
    CVOpenGLESTextureRef texture = NULL;
    
    CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, _ref, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RGBA, bufferWidth, bufferHeight, GL_BGRA, GL_UNSIGNED_BYTE, 0, &texture);
    
    if (texture == NULL || err) {
        return;
    }
    
    GLuint name = CVOpenGLESTextureGetName(texture);
    glBindTexture(GL_TEXTURE_2D, name);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    CVOpenGLESTextureCacheFlush(_ref, 0);
    CVBufferRelease(pixelBuffer);
    CFRelease(texture);
    return;
}

- (void)dealloc
{
    NSLog(@"%@ ------ dealloc",self.class);
    if (self.playerItem == nil) {
        return;
    }
    [self.playerItem removeObserver:self forKeyPath:@"status" context:VideoPlayer_PlayerItemStatusContext];
}


@end
