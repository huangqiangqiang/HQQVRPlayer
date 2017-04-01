//
//  HQQVRDirectorManager.h
//  Pods
//
//  Created by 黄强强 on 17/4/1.
//
//

#import <Foundation/Foundation.h>
#import "HQQVRPlayer.h"
#import "HQQVRDirector.h"

@interface HQQVRDirectorManager : NSObject

+ (instancetype)manager;
@property (nonatomic, strong) NSMutableArray *directors;
@property (nonatomic, assign) HQQVRDisplayType displayType;

@end
