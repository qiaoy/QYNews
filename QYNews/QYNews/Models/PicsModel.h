//
//  PicsModel.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/3.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "JSONModel.h"
#import "PicListModel.h"

@protocol PicsModel <NSObject>
@end

@interface PicsModel : JSONModel
@property (nonatomic) NSInteger total;
@property (nonatomic) NSArray   <PicListModel>*list;
@end
