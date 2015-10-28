//
//  ScrollConModel.m
//  QYNews
//
//  Created by qiaoyan on 15/10/7.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import "ScrollConModel.h"

@implementation ScrollConModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.id = value;
    }
}
+(instancetype)parseDataWithRespondsData:(id)respondsData {
    NSDictionary *dic = respondsData[@"data"];
    ScrollConModel *model = [[ScrollConModel alloc]initWithDictionary:dic error:nil];
    return model;
}
@end
