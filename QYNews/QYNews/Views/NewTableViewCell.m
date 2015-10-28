
//
//  NewTableViewCell.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/18.
//  Copyright (c) 2015年 乔岩. All rights reserved.
//

#import "NewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TimeChannel.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface NewTableViewCell ()
@property (nonatomic) Reachability *conn;
@property (nonatomic) BOOL isNetWifi;
@property (nonatomic) AppDelegate *delegate;
@end

@implementation NewTableViewCell

- (void)awakeFromNib {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//- (void)addNetNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkState) name:kReachabilityChangedNotification object:nil];
//    self.conn = [Reachability reachabilityForInternetConnection];
//    [self.conn startNotifier];
//}
- (void)checkNetworkState {
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        self.isNetWifi = YES;
    }
}
- (void)updateWithModel:(NewModel *)model {
    //[self addNetNotification];
    [self checkNetworkState];
    if (self.isNetWifi) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];

    }else {
        NSString *wifi = [[NSUserDefaults standardUserDefaults]objectForKey:isWifi];
        BOOL is_wifi = [wifi boolValue];
        if (!is_wifi) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
        }
    }
    self.headImageView.layer.cornerRadius  = 5;
    self.headImageView.layer.masksToBounds = YES;
    self.titleLabel.text = model.title;
    self.bodyLabel.text  = model.long_title;
    [self updateTime:model.pubDate];
}
- (void)updateTime:(NSString *)time {
    self.timeLabel.text  = [TimeChannel calculateLeftTimeFrom:time];
}
@end
