//
//  UIView+Ext.h
//  NeihanDemo
//
//  Created by lijinghua on 15/9/6.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Ext)

@property(nonatomic)CGFloat topX;
@property(nonatomic)CGFloat topY;
@property(nonatomic)CGFloat width;
@property(nonatomic)CGFloat height;

@property(nonatomic,readonly)CGFloat bottomY;

@end
