//
//  ContentCollectionViewController.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/26.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SetTitleScrollViewOffsetBlockType) (NSInteger index);
@interface ContentCollectionViewController : UICollectionViewController

+ (instancetype)sharedInstance;

@property (nonatomic,copy)SetTitleScrollViewOffsetBlockType setOffsetBlock;
@end
