
//
//  BackgroundView.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/24.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "BackgroundView.h"


@interface BackgroundView ()
@property UIView *drawerView;
@end
@implementation BackgroundView

- (id)initWithFrame:(CGRect)frame  drawer:drawerView isDrawer:(IsDrawerBlockType)block{
    if (self = [super initWithFrame:frame]) {
        self.myBlock = block;
        self.drawerView = drawerView;
        [self customMySelf];
        [self addSwipeGesture];
    }
    return self;
}
- (void)customMySelf {
    self.backgroundColor = [UIColor lightGrayColor];
    self.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
    [self addGestureRecognizer:tap];
}
- (void)tapGestureClick:(UITapGestureRecognizer *)gesture {
    [self drawerMoveRight];
}
- (void)drawerMoveRight {
    [UIView animateWithDuration:0.5 animations:^{
        self.drawerView.frame = CGRectMake(-ScreenWidth/3.0*2, 64, ScreenWidth/3.0*2, ScreenHeight -64);
        self.alpha = 0.0;
        for (int index = 0; index < 4; index ++) {
            UIButton *button = (UIButton *)[_drawerView viewWithTag:DrawerButTag + index];
            [UIView animateWithDuration:0.5 animations:^{
                button.frame = CGRectMake(-button.width, button.topY, button.width, button.height);
            }];
        }
    }];
    if (self.myBlock) {
        self.myBlock(NO);
    }
}
#pragma mark  - 添加手势 -
- (void)addSwipeGesture {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGesture];
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    [self drawerMoveRight];
}
@end
