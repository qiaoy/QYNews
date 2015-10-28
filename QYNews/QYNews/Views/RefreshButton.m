


//
//  RefreshButton.m
//  QYNews
//
//  Created by qiaoyan on 15/10/8.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import "RefreshButton.h"

@implementation RefreshButton
+ (instancetype)sharedInstance {
    static RefreshButton *s_refreshBut = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_refreshBut = [[RefreshButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, ScreenHeight - 60, 40, 40)];
    });
    return s_refreshBut;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customMyself];
    }
    return self;
}
- (void)customMyself {
    self.layer.cornerRadius  = 20;
    self.layer.masksToBounds = YES;
    self.backgroundColor     = [UIColor whiteColor];
    [self setImage:[UIImage imageNamed:@"shuaxin2.png"] forState:UIControlStateNormal];
    [self addPanGesture];
    [self addTarget:self action:@selector(refreshButClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addPanGesture {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [self addGestureRecognizer:panGesture];
}
- (void)refreshButClick:(UIButton *)button {
    [UIView animateWithDuration:0.3 animations:^{
        button.transform = CGAffineTransformRotate(button.transform, M_PI);
        [UIView animateWithDuration:0.3 animations:^{
            button.transform = CGAffineTransformRotate(button.transform, M_PI);
        }];
    }];
    if (self.refreshButBlock) {
        self.refreshButBlock();
    }
}
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    if (gesture.view.topY < 64) {
        [UIView animateWithDuration:0.2 animations:^{
            gesture.view.frame = CGRectMake(gesture.view.topX, 64 + ScrollView_H, gesture.view.width, gesture.view.height);
        }];
        return;
    }
    if (gesture.view.bottomY > ScreenHeight) {
        [UIView animateWithDuration:0.2 animations:^{
            gesture.view.frame = CGRectMake(gesture.view.topX, ScreenHeight - 50, gesture.view.width, gesture.view.height);
        }];
        return;
    }
    if (gesture.view.topX < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            gesture.view.frame = CGRectMake(20, gesture.view.topY, gesture.view.width, gesture.view.height);
        }];
        return;
    }
    if (gesture.view.topX + gesture.view.width > ScreenWidth) {
        [UIView animateWithDuration:0.2 animations:^{
            gesture.view.frame = CGRectMake(ScreenWidth - 50, gesture.view.topY, gesture.view.width, gesture.view.height);
        }];
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        //手势识别成功，并且手势持续进行中
        UIView *view = gesture.view;
        UIView *superView = self.superview;
        [superView bringSubviewToFront:view];
        //手势在self.view上移动的多少
        CGPoint offset = [gesture translationInView:superView];
        CGPoint newCenter = CGPointMake(view.center.x+offset.x, view.center.y+offset.y);
        view.center = newCenter;
        //手势的效果会累加，translation一直累加
        //重新初始化，去除原来的累加效果
        [gesture setTranslation:CGPointZero inView:superView] ;
    }
}
@end
