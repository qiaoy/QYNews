



//
//  InfoViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"消息中心";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -
#pragma mark 重写父类的方法
- (void)setRightButtonImage:(UIButton *)rightButton {
    [rightButton setImage:[UIImage imageNamed:@"titlebar_search_result_add_press.png"] forState:UIControlStateNormal];
}

@end
