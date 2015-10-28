//
//  FatherViewController.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FatherViewController : UIViewController
@property (nonatomic) UIView *alphaView;
//- (void)customNavigationRightBar;
//要重写的方法
- (void)setRightButtonImage:(UIButton *)rightButton;
- (void)setLeftButtonImage:(UIButton *)leftButton;
- (void)leftButtonClick:(UIButton *)button;
- (void)rightButtonClick:(UIButton *)button;
@end
