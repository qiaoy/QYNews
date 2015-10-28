//
//  NewTableViewCell.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/18.
//  Copyright (c) 2015年 乔岩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewModel.h"

typedef NS_ENUM(NSInteger,NetStyle) {
    
    NetNone  = 0,
    Net  = 1,
    NFKScrollViewDidMoveRight = 2,
};

@interface NewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;


- (void)updateWithModel:(NewModel *)model;
@end
