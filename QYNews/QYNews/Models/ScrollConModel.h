//
//  ScrollConModel.h
//  QYNews
//
//  Created by qiaoyan on 15/10/7.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import "JSONModel.h"
#import "SCPicsModel.h"

@interface ScrollConModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*pic;
@property (nonatomic,copy) NSString <Optional>*id;
@property (nonatomic,copy) NSString <Optional>*title;
@property (nonatomic,copy) NSString <Optional>*long_title;
@property (nonatomic,copy) NSString <Optional>*link;
@property (nonatomic,copy) NSString <Optional>*cover_img;
@property (nonatomic,copy) NSString <Optional>*comments;
@property (nonatomic,copy) NSString <Optional>*pub_date;
@property (nonatomic,copy) NSArray  <Optional>*pics_module;

+(instancetype)parseDataWithRespondsData:(id)respondsData;
@end
