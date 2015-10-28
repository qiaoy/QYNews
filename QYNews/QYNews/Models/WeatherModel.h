//
//  WeatherModel.h
//  网易新闻
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
//温度
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, copy) NSString *l_tmp;
@property (nonatomic, copy) NSString *h_tmp;
//时间
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *week;

//城市
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *weather;
//风
@property (nonatomic, copy) NSString *WD;
@property (nonatomic, copy) NSString *WS;

+ (NSMutableArray *)parseRespondData:(id)respondData;
@end
