//
//  NSBundle+HQQVRPlayer.m
//  Pods
//
//  Created by 黄强强 on 17/4/1.
//
//

#import "NSBundle+HQQVRPlayer.h"
#import "HQQVRPlayer.h"

@implementation NSBundle (HQQVRPlayer)

+ (NSString *)hqq_vrPlayerBundle
{
    static NSBundle *vrPlayerBundle = nil;
    if (vrPlayerBundle == nil) {
        vrPlayerBundle = [[[NSBundle bundleForClass:[HQQVRPlayer class]] resourcePath] stringByAppendingPathComponent:@"HQQVRResource.bundle"];
    }
    return vrPlayerBundle;
}

+ (NSString *)hqq_vertexShaderPath
{
    return [[self hqq_vrPlayerBundle] stringByAppendingPathComponent:@"vertex_shader.glsl"];
}

+ (NSString *)hqq_fragmentShaderPath
{
    return [[self hqq_vrPlayerBundle] stringByAppendingPathComponent:@"fragment_shader.glsl"];
}

+ (UIImage *)hqq_vrIcon
{
    NSString *vrIconPath = [[self hqq_vrPlayerBundle] stringByAppendingPathComponent:@"vr_icon@2x.png"];
    return [UIImage imageNamed:vrIconPath];
}

+ (UIImage *)hqq_backIcon
{
    NSString *vrIconPath = [[self hqq_vrPlayerBundle] stringByAppendingPathComponent:@"back_icon@2x.png"];
    return [UIImage imageNamed:vrIconPath];
}

@end
