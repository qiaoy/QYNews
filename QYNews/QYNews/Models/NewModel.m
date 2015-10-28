//
//  NewModel.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/18.
//  Copyright (c) 2015年 乔岩. All rights reserved.
//

#import "NewModel.h"

@implementation NewModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.id = value;
    }
}
+ (NSDictionary *)parseDataWithRespondsData:(id)respondsData {
    NSMutableArray *contentModelArr = [NSMutableArray array];
    NSMutableArray *headModelArr    = [NSMutableArray array];
    NSDictionary *dataDic = respondsData[@"data"];
    NSArray *dataArr      = dataDic[@"list"];
    for (int index = 0; index < dataArr.count; index ++) {
        NSDictionary *dic = [dataArr objectAtIndexedSubscript:index];
        if ([dic[@"category"] isEqualToString:@"sponsor"] ||[dic[@"category"] isEqualToString:@"plan"] || [dic[@"category"] isEqualToString:@"ad"]) {
            continue;
        }
        if (!dic[@"category"]) {
            continue;
        }
        if ([dic[@"category"] isEqualToString:@"cms"] ||[dic[@"category"] isEqualToString:@"hdpic"] ) {
            NewModel *model = [[NewModel alloc]initWithDictionary:dic error:nil];
            if (dic[@"is_focus"]) {
                model.postt = [NSString stringWithFormat:@"news_%@_focus_%d",@"%@",index];
                [headModelArr addObject:model];
            }
            if (!dic[@"is_focus"] ) {
                if ([dic[@"category"] isEqualToString:@"hdpic"]) {
                    continue;
                }
                [contentModelArr addObject:model];
            }
        }
    }
    NSDictionary *dic = @{HEADKEY:headModelArr,CONTENTKEY:contentModelArr};
    return dic;
}
@end
