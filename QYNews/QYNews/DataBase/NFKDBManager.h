//
//  NFKDBManager.h
//  NewFirstKnow
//
//  Created by qianfeng on 15/10/6.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentModel.h"
#import "ScrollConModel.h"

@interface NFKDBManager : NSObject

+ (instancetype)sharedInstance;
//第一种类型
//添加
- (void)addNewInfo:(id)model type:(NSString *)type;
//删除
- (void)deleteNewInfo:(id)model type:(NSString *)type;
//根据type读取appInfo
- (NSArray *)readNewInfoList:(NSString *)type;
//判断类型为type的app 是否存在
- (BOOL)isNewInfoExist:(id)model type:(NSString *)type;

////第二种另外类型
////添加
//- (void)addScrollNewInfo:(ScrollConModel *)model type:(NSString *)type;
////删除
//- (void)deleteScrollNewInfo:(ScrollConModel *)model type:(NSString *)type;
////根据type读取appInfo
//- (NSArray *)readScrollNewInfoList:(NSString *)type;
////判断类型为type的app 是否存在
//- (BOOL)isScrollNewInfoExist:(ScrollConModel *)model type:(NSString *)type;
@end
