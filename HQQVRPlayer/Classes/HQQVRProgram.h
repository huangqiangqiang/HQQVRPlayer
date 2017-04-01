//
//  HQQVRProgram.h
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import <Foundation/Foundation.h>

@interface HQQVRProgram : NSObject

+ (instancetype)createProgram;

@property (nonatomic, assign) int a_PositionHandler;
@property (nonatomic, assign) int a_TexCoordHandler;
@property (nonatomic, assign) int u_TextureHandler;
@property (nonatomic, assign) int MVPMatrixHandler;

@end
