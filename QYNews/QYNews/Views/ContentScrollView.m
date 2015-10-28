//
//  ContentScrollView.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/5.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "ContentScrollView.h"

@implementation ContentScrollView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customMyself];
    }
    return self;
}
- (void)customMyself {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
}
@end