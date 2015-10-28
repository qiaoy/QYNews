//
//  TitleTableViewCell.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/5.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)updateWithModel:(NewModel *)model;
@end
