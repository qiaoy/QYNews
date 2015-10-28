//
//  ContentModel.m
//  NewFirstKnow
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "ContentModel.h"

@implementation ContentModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.id = value;
    }
}
+(instancetype )parseDataWithRespondsData:(id)respondsData {

    NSDictionary *dataDic = respondsData[@"data"];
    ContentModel *model = [[ContentModel alloc]initWithDictionary:dataDic error:nil];
    return model;
}
@end
