

//
//  OfflineSetViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/23.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import "OfflineSetViewController.h"

@interface OfflineSetViewController ()

@end

@implementation OfflineSetViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"离线设置";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma 重写父类方法
- (void)setRightButtonImage:(UIButton *)rightButton {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
