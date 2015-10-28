//
//  NetDataEngine.m
//  NewFirstKnow
//
//  Created by qianfeng on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import "NetDataEngine.h"
#import "AFNetworking.h"

@interface NetDataEngine ()

@property (nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation NetDataEngine

+ (instancetype)sharedInstance {
    static NetDataEngine *s_netEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_netEngine = [[NetDataEngine alloc]init];
    });
    return s_netEngine;
}
- (id)init {
    if (self = [super init]) {
        self.manager = [[AFHTTPRequestOperationManager alloc]init];
        NSSet *currentAcceptSet = self.manager.responseSerializer.acceptableContentTypes;
        NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
        [mset addObject:@"text/html"];
        self.manager.responseSerializer.acceptableContentTypes = mset;
    }
    return self;
}
- (void)GET:(NSString *)url success:(successBlockType)successBlock failed:(failedBlockType)failedBlock {
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}
//新闻列表数据
- (void)requestNewListFrom:(NSString *)url success:(successBlockType)successBlock failed:(failedBlockType)failedBlock {
    [self GET:url success:successBlock failed:failedBlock];
}
//请求详情页面数据
- (void)requestNewContentFrom:(NSString *)url success:(successBlockType)successBlock failed:(failedBlockType)failedBlock {
    [self GET:url success:successBlock failed:failedBlock];
}
//请求天气数据
- (void)requestWeatherFrom:(NSString *)url success:(successBlockType)successBlock failed:(failedBlockType)failedBlock {
    [self GET:url success:successBlock failed:failedBlock];
}
@end
