//
//  NewScrollView.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/7.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//
#define padding 8
#import "NewScrollView.h"

@interface NewScrollView ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UITextView  *textView;
@property (nonatomic) UILabel     *contentLabel;
@property (nonatomic) UILabel     *pageLabel;
@end

@implementation NewScrollView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customMyself];
    }
    return self;
}
- (void)customMyself {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    self.pagingEnabled   = YES;
    self.backgroundColor = [UIColor blackColor];
//    [self addImageVeiw];
//    [self addlabel];
//    [self addTextView];
}

@end
