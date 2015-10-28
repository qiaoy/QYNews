//
//  ContentPicModel.h
//  NewFirstKnow
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "JSONModel.h"

@interface ContentPicModel : JSONModel

@property (nonatomic,copy) NSString <Optional>*pic;
@property (nonatomic,copy) NSString <Optional>*alt;
@property (nonatomic,copy) NSString <Optional>*kpic;
@property (nonatomic,copy) NSString <Optional>*width;
@property (nonatomic,copy) NSString <Optional>*height;

@end
