//
//  RefreshButton.h
//  QYNews
//
//  Created by qiaoyan on 15/10/8.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RefreshButType) (void);
@interface RefreshButton : UIButton
+ (instancetype)sharedInstance;

@property (nonatomic,copy) RefreshButType refreshButBlock;
@end
