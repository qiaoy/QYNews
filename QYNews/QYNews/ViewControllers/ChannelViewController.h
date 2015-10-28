//
//  ChannelViewController.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import "FatherViewController.h"

typedef void (^JmpBlockType) (NSString *title);
typedef void (^RefreshScroolViewOffsetType) (NSString *title);
typedef void (^RefreshCollectionViewBlockType) (NSString *title);

@interface ChannelViewController : FatherViewController
+ (instancetype)sharedInstance;

@property (nonatomic,copy) JmpBlockType jmpClock;
@property (nonatomic,copy) RefreshScroolViewOffsetType    reBlock;
@property (nonatomic,copy) RefreshCollectionViewBlockType reCollectionBlock;
@property (nonatomic,copy) NSString *butTitle;
@end
