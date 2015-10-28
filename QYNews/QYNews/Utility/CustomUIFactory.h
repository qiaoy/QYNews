//
//  CustomUIFactory.h
//  NewFirstKnow
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUIFactory : NSObject
//创建一个UIView，指定frame 背景色
+ (UIView*)createViewFrame:(CGRect)frame backgroundColor:(UIColor*)color;

//创建一个UILabel，指定frame，text，textColor
+ (UILabel*)createLabelFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)color font:(float)font;

//创建一个UIImageView 指定frame 和 显示的图片
+ (UIImageView*)createImageViewFrame:(CGRect)frame image:(UIImage*)image;
@end
