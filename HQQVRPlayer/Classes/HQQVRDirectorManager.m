//
//  HQQVRDirectorManager.m
//  Pods
//
//  Created by 黄强强 on 17/4/1.
//
//

#import "HQQVRDirectorManager.h"

@interface HQQVRDirectorManager()
@end

@implementation HQQVRDirectorManager

+ (instancetype)manager
{
    return [[self alloc] init];
}

- (void)setDisplayType:(HQQVRDisplayType)displayType
{
    [self.directors removeAllObjects];
    
    if (displayType == HQQVRDisplayTypeVR) {
        HQQVRDirector *directorLeft = [[HQQVRDirector alloc] init];
        HQQVRDirector *directorRight = [[HQQVRDirector alloc] init];
        [self.directors addObject:directorLeft];
        [self.directors addObject:directorRight];
    }
    else{
        HQQVRDirector *director = [[HQQVRDirector alloc] init];
        [self.directors addObject:director];
    }
}

- (NSMutableArray *)directors
{
    if (!_directors) {
        _directors = [NSMutableArray array];
    }
    return _directors;
}


@end
