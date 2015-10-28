//
//  SCPicsModel.h
//  QYNews
//
//  Created by qiaoyan on 15/10/7.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import "JSONModel.h"

@interface SCPicsModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*pic;
@property (nonatomic,copy) NSString <Optional>*alt;
@property (nonatomic,copy) NSString <Optional>*kpic;
@property (nonatomic,copy) NSString <Optional>*width;
@property (nonatomic,copy) NSString <Optional>*height;

@end
