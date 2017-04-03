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

@property (nonatomic, strong) NSMutableArray *directors;
@property (nonatomic, assign) HQQVRDisplayType displayType;
@property (nonatomic, assign) HQQVRInteractiveType interactiveType;

@end
