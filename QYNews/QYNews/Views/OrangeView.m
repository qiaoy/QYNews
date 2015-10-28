//
//  OrangeView.m
//  QYNews
//
//  Created by qiaoyan on 15/10/17.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//
#define OrangeViewTag 233
#import "OrangeView.h"

@implementation OrangeView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customMyself];
    }
    return self;
}
- (void)customMyself {
    self.backgroundColor = [UIColor orangeColor];
    self.tag = OrangeViewTag;
}
@end
