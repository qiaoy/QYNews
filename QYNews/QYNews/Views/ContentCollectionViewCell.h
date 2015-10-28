//
//  ContentCollectionViewCell.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/26.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCollectionViewCell : UICollectionViewCell

@property (nonatomic) UITableView *ContenttableView;
@property (nonatomic,copy) NSString *title;

- (void)updateWith:(NSString *)title;

@end
