



//
//  TimeChannel.m
//  NewFirstKnow
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "TimeChannel.h"

@implementation TimeChannel
+(NSString*)calculateLeftTimeFrom:(NSString*)dateString
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSString *grabTime = [dateString substringToIndex:10];
    NSTimeInterval time = nowTime - [grabTime floatValue];
    if (time<60) {
        return @"刚刚";
    }
    else if (time <60*60) {
        return [NSString stringWithFormat:@"%.0f分钟前",time/60];
    }
    else if (time <3600*24){
        return [NSString stringWithFormat:@"%.0f小时前",time/3600];
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy/MM/dd";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString floatValue]];
        return [formatter stringFromDate:date];
    }
    return nil;
}
+ (NSString *)currentTime {
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f",nowTime];
}
+(NSString *)calculatePushTimeFrom:(NSString*)dateString {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[dateString integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd hh:mm:ss";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString*)calculateLeftTimeFromNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //得到日历类，由它来帮我们计算两个日期之间的差距
    NSUInteger flag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [calendar components:flag fromDate:now];
    
    NSArray *array = @[@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSInteger index = comps.weekday - 1;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowDate = [formatter stringFromDate:date];
    NSString *current = [NSString stringWithFormat:@"%@ %@",nowDate,array[index]];
    
    return current;
}
@end
