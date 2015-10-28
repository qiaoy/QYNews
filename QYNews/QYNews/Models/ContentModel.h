//
//  ContentModel.h
//  NewFirstKnow
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicsModel.h"

@interface ContentModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*pic;
@property (nonatomic,copy) NSString <Optional>*id;
@property (nonatomic,copy) NSString <Optional>*title;
@property (nonatomic,copy) NSString <Optional>*long_title;
@property (nonatomic,copy) NSString <Optional>*source;
@property (nonatomic,copy) NSString <Optional>*pub_date;
@property (nonatomic,copy) NSDictionary <Optional>*keys;
@property (nonatomic,copy) NSString <Optional>*share_lead;
@property (nonatomic,copy) NSArray  <Optional>*pics;
@property (nonatomic,copy) NSString <Optional>*content;
+(instancetype)parseDataWithRespondsData:(id)respondsData;
@end
