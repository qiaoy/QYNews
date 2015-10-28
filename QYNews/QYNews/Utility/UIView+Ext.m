//
//  UIView+Ext.m
//  NeihanDemo
//
//  Created by lijinghua on 15/9/6.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "UIView+Ext.h"

@implementation UIView (Ext)

- (CGFloat)topX
{
    return self.frame.origin.x;
}

- (CGFloat)topY
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)bottomY
{
    return self.topY + self.height;
}

- (void)setTopX:(CGFloat)topX
{
    CGRect frame = self.frame;
    frame.origin.x = topX;
    self.frame = frame;
}

- (void)setTopY:(CGFloat)topY{
    CGRect frame = self.frame;
    frame.origin.y = topY;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
@end
