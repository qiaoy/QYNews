//
//  BackgroundView.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/24.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^IsDrawerBlockType) (BOOL isDrawer);
@interface BackgroundView : UIView
@property (nonatomic) BOOL isDrawer;
@property (nonatomic,copy) IsDrawerBlockType myBlock;
- (id)initWithFrame:(CGRect)frame  drawer:drawerView isDrawer:(IsDrawerBlockType)block;
@end
