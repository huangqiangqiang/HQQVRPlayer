//
//  HQQViewController.m
//  HQQVRPlayer
//
//  Created by huangqiangqiang on 03/31/2017.
//  Copyright (c) 2017 huangqiangqiang. All rights reserved.
//

#import "HQQViewController.h"
#import "HQQBitmapViewController.h"
#import "HQQVideoViewController.h"

@interface HQQViewController ()
@property (nonatomic, strong) NSArray *dataList;
@end

@implementation HQQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"HQQVRPlayer";
    
    self.dataList = @[
                      @"Image Example",
                      @"Video Example"
                      ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HQQVRCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    if (indexPath.row == 0) {
        vc = [[HQQBitmapViewController alloc] init];
    }
    else if (indexPath.row == 1) {
        vc = [[HQQVideoViewController alloc] init];
    }
    [self presentViewController:vc animated:YES completion:nil];
}

@end
