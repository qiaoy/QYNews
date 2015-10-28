//
//  NetDataEngine.h
//  NewFirstKnow
//
//  Created by qianfeng on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlockType)(id response);
typedef void(^failedBlockType)(NSError *error);

@interface NetDataEngine : NSObject
+ (instancetype)sharedInstance;

- (void)requestNewListFrom:(NSString *)url success:(successBlockType)successBlock failed:(failedBlockType)failedBlock;
- (void)requestNewContentFrom:(NSString *)url success:(successBlockType)successBlock failed:(failedBlockType)failedBlock;

- (void)requestWeatherFrom:(NSString *)url success:(successBlockType)successBlock failed:(failedBlockType)failedBlock;
@end
