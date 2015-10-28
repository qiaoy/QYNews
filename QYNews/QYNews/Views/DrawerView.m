

//
//  DrawerView.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/24.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//
#define Button_w 50
#define BUtton_h 50
#define Label_h  20
#import "DrawerView.h"
#import "ShakeViewController.h"

@interface DrawerView ()
@property (nonatomic) UIViewController *VC; //父视图控制器
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView  *imageView;
@property (nonatomic) UIAlertView  *alertView;
@end
@implementation DrawerView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createScrollView];
        [self customMyself];
        [self createPadView];
        [self addLoginViewToMyself];
        [self addButtonToMyself];
    }
    return self;
}

- (void)customMyself {
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 添加子视图 -
- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.bounces = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    [self addSubview:self.scrollView];
}
- (void)addLoginViewToMyself {
    self.imageView        = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon-60@2x.png"]];
    self.imageView.bounds = CGRectMake(0, 0, self.width/2, self.width/2);
    self.imageView.center = CGPointMake(self.width/2,  self.width/4 + 20);
    self.imageView.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:self.imageView];
}
//创建button
- (UIButton *)CreateButton:(int)index {
    NSArray *titles  = @[@"摇一摇",@"收藏",@"离线",@"设置"];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-self.width, self.imageView.bottomY + 25+(ScrollView_H + Label_h+12)*index, self.width, ScrollView_H)];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.tag = DrawerButTag +index;
    
    [button setTitle:[titles objectAtIndex:index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(drawerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    return button;
}
//but之间的填充
- (UIView *)createPadView {
    UIView *padView = [[UIView alloc]initWithFrame:CGRectZero];
    padView.backgroundColor = [UIColor orangeColor];
    padView.layer.cornerRadius  = 10;
    padView.layer.masksToBounds = YES;
    padView.alpha = 0.5;
    [self.scrollView addSubview:padView];
    return padView;
}

- (void)addButtonToMyself {
    NSArray *images = @[@"yaoyiyao3.png",@"shoucang3.png",@"lixian3.png",@"setting3.png"];
    for (int index = 0; index < 4; index ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 20, 20)];
        imageView.image        = [UIImage imageNamed:[images objectAtIndex:index]];
        UIButton *button       = [self CreateButton:index];
        [button addSubview:imageView];
        UIView *padView = [self createPadView];
        padView.frame   = CGRectMake(20, button.bottomY+6, self.width- 20*2, Label_h);
        if (index == 3) {
            self.scrollView.contentSize = CGSizeMake(0, padView.bottomY);
        }
    }
    
}

- (UIAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未开通，敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
    return _alertView;
}
#pragma mark -
#pragma mark ButtonClick

- (void)drawerButtonClick:(UIButton *)button {
    UIResponder *responder = self.nextResponder;
    while (responder != nil && ![responder isKindOfClass:[UIViewController class]]) {
        responder = responder.nextResponder;
    }
    self.VC = (UIViewController *)responder;
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"rippleEffect";
    transition.delegate = self;
    [self.VC.navigationController.view.layer addAnimation:transition forKey:nil];
    
    if (button.tag == DrawerButTag) {
        ShakeViewController *shakeVC = [[ShakeViewController alloc]init];
        [self.VC.navigationController pushViewController:shakeVC animated:YES];
    }
    if (button.tag == DrawerButTag + 1) {
        CollectionViewController *collectionVC = [[CollectionViewController alloc]init];
        [self.VC.navigationController pushViewController:collectionVC animated:YES];
    }
    if (button.tag == DrawerButTag + 2) {
        
        [self addSubview:self.alertView];
        [self.alertView show];
        
    }
    if (button.tag == DrawerButTag + 3) {
        SettingViewController *settingVC = [[SettingViewController alloc]init];
        [self.VC.navigationController pushViewController:settingVC animated:YES];
    }
}
- (void)subButtonClick:(UIButton *)button {
    OfflineSetViewController *offlineSetVC = [[OfflineSetViewController alloc]init];
    [self.VC.navigationController pushViewController:offlineSetVC animated:YES];
}
@end
