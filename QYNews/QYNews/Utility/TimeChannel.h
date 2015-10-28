//
//  TimeChannel.h
//  NewFirstKnow
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeChannel : NSObject
+(NSString *)calculateLeftTimeFrom:(NSString*)dateString;
+(NSString *)calculatePushTimeFrom:(NSString*)dateString;

+(NSString*)calculateLeftTimeFromNow;
@end
