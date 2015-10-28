//
//  HeadOfContentScrollVeiw.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/4.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^HeadViewBlockTyoe) (NSMutableArray *contentArr);
@interface HeadOfContentScrollVeiw : UIScrollView
@property (nonatomic,copy) HeadViewBlockTyoe contentViewBlock;
@end
