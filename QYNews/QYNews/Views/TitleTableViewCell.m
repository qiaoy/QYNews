

//
//  TitleTableViewCell.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/5.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "TitleTableViewCell.h"

@implementation TitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)updateWithModel:(NewModel *)model {
    self.titleLabel.text = model.title;
    self.bodyLabel.text  = model.long_title;
    [self updateTime:model.pubDate];
}
- (void)updateTime:(NSString *)time {
    self.timeLabel.text  = [TimeChannel calculateLeftTimeFrom:time];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
