//
//  HQQPlayerViewController.h
//  HQQVRPlayer
//
//  Created by 黄强强 on 17/4/2.
//  Copyright © 2017年 huangqiangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQQPlayerViewController : UIViewController

// overwrite
- (void)displayChanged:(int)index;
- (void)interactiveChanged:(int)index;

@end
