//
//  WeatherModel.m
//  网易新闻
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

+ (NSMutableArray *)parseRespondData:(id)respondData{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *resultDic = respondData[@"retData"];
    
    WeatherModel *model = [[WeatherModel alloc] init];
    [model setValuesForKeysWithDictionary:resultDic];
    [array addObject:model];
    return array;
}
@end
