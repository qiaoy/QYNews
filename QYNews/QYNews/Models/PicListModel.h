//
//  PicListModel.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/3.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "JSONModel.h"

@protocol PicListModel <NSObject>
@end

@interface PicListModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*pic;
@property (nonatomic,copy) NSString <Optional>*alt;
@property (nonatomic,copy) NSString <Optional>*kpic;
@end
