#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HQQGLUtil.h"
#import "HQQVRDirector.h"
#import "HQQVRDirectorManager.h"
#import "HQQVRPlayer.h"
#import "HQQVRProgram.h"
#import "HQQVRRenderer.h"
#import "HQQVRSphereObject.h"
#import "HQQVRTexture.h"
#import "HQQVRViewController.h"
#import "NSBundle+HQQVRPlayer.h"

FOUNDATION_EXPORT double HQQVRPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char HQQVRPlayerVersionString[];

