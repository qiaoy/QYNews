//
//  CustomUIFactory.m
//  NewFirstKnow
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "CustomUIFactory.h"

@implementation CustomUIFactory
//创建一个UIView，指定frame 背景色
+ (UIView*)createViewFrame:(CGRect)frame backgroundColor:(UIColor*)color {
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

//创建一个UILabel，指定frame，text，textColor
+ (UILabel*)createLabelFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)color font:(float)font{
    UILabel *label  = [[UILabel alloc]initWithFrame:frame];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

//创建一个UIImageView 指定frame 和 显示的图片
+ (UIImageView*)createImageViewFrame:(CGRect)frame image:(UIImage*)image {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = image;
    return imageView;
}
@end
