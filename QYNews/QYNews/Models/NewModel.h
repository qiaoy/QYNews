//
//  NewModel.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/18.
//  Copyright (c) 2015年 乔岩. All rights reserved.
//

#import "JSONModel.h"
#import "PicsModel.h"

@interface NewModel : JSONModel

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *long_title;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString <Optional>*pic;
@property (nonatomic,copy) NSString <Optional>*kpic;
@property (nonatomic,copy) NSString <Optional>*bpic;
@property (nonatomic,copy) NSString *intro;
@property (nonatomic,copy) NSString *pubDate;
@property (nonatomic,copy) NSString *comments;
@property (nonatomic,copy) PicsModel<Optional>*pics;
@property (nonatomic,copy) NSString <Optional>*feedShowStyle;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString <Optional>*comment;
@property (nonatomic,copy) NSDictionary <Optional>*comment_count_info;
//model的category 为hdpic类型的，加载网络是需要
@property (nonatomic) NSString <Optional>*postt;
+ (NSDictionary *)parseDataWithRespondsData:(id)respondsData;
@end
