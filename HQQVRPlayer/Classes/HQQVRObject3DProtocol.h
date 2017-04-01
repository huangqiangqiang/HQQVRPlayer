//
//  HQQVRObject3DProtocol.h
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import <Foundation/Foundation.h>
#import "HQQVRProgram.h"

@protocol HQQVRObject3DProtocol <NSObject>

@required;
- (void)createObject3D;
- (void)updateVertex:(HQQVRProgram *)program;
- (void)updateTexture:(HQQVRProgram *)program;
- (void)draw;

@end
