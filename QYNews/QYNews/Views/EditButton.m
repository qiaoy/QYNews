//
//  EditButton.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/24.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "EditButton.h"
#import "ChannelViewController.h"
@interface EditButton ()

@end
@implementation EditButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customMyself];
    }
    return self;
}
- (void)customMyself {
    
    self.backgroundColor   = [UIColor colorWithRed:0.93 green:0.98 blue:0.95 alpha:1.0];
    self.layer.borderColor = [UIColor colorWithRed:0.9 green:0.98 blue:0.95 alpha:1.0].CGColor;
    self.layer.borderWidth = 1;

    [self setImage:[UIImage imageNamed:@"plus1.png"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editButtonClick:(UIButton *)button {
    

    button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
    button.alpha = 0;
 
    button.transform = CGAffineTransformIdentity;
    button.alpha = 1;
        
    UIResponder *responder = self.nextResponder;
    while (responder != nil && ![responder isKindOfClass:[UIViewController class]]) {
        responder = responder.nextResponder;
    }
    UIViewController *VC = (UIViewController *)responder;

    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"rippleEffect";
    transition.delegate = self;
    [VC.navigationController.view.layer addAnimation:transition forKey:nil];
        
    ChannelViewController *channelVC = [ChannelViewController sharedInstance];
    [VC.navigationController pushViewController:channelVC animated:YES];
   
}
@end
