//
//  NFKDBManager.m
//  NewFirstKnow
//
//  Created by qianfeng on 15/10/6.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "NFKDBManager.h"
#import "FMDatabase.h"

@interface NFKDBManager () {
    FMDatabase *_db; //数据库实例
}
@end

@implementation NFKDBManager
+ (instancetype)sharedInstance {
    static NFKDBManager *s_dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_dbManager = [[NFKDBManager alloc]init];
    });
    return s_dbManager;
}
- (NSString *)dbPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/NFK.db"];
}
- (id)init {
    if (self = [super init]) {
        _db = [[FMDatabase alloc]initWithPath:[self dbPath]];
        if ([_db open]) {
            [self createTable];
        }
    }
    return self;
}
- (void)createTable {
    NSString *sql = @"create table if not exists newsInfo(serialId integer primary key autoincrement,newId text,newTitle text,newLongTitle text,newIconUrl text,newPushTime text,type text)";
    if (![_db executeUpdate:sql]) {
        NSLog(@"创建失败");
    }
}

//添加
- (void)addNewInfo:(ContentModel *)model type:(NSString *)type {
    NSString *sql = @"insert into newsInfo(newId,newTitle,newLongTitle,newIconUrl,newPushTime,type)values(?,?,?,?,?,?)";
    if (![_db executeUpdate:sql,model.id,model.title,model.long_title,model.pic,model.pub_date,type]) {
        NSLog(@"插入失败");
    }
}
//删除
- (void)deleteNewInfo:(ContentModel *)model type:(NSString *)type {
    NSString *sql = @"delete from newsInfo where newId = ? AND type = ?";
    if (![_db executeUpdate:sql,model.id,type]) {
        NSLog(@"删除失败");
    }
}
//根据type读取newInfo
- (NSArray *)readNewInfoList:(NSString *)type {
    NSMutableArray *newArray = [NSMutableArray array];
    NSString *sql = @"select * from newsInfo where type = ?";
    FMResultSet *resultSet = [_db executeQuery:sql,type];
    while (resultSet.next) {
        NewModel *model = [[NewModel alloc]init];
        model.id = [resultSet stringForColumn:@"newId"];
        model.title = [resultSet stringForColumn:@"newTitle"];
        model.long_title = [resultSet stringForColumn:@"newLongTitle"];
        model.pic = [resultSet stringForColumn:@"newIconUrl"];
        model.pubDate = [resultSet stringForColumn:@"newPushTime"];
        [newArray addObject:model];
    }
    [resultSet close];
    return newArray;
}
//判断类型为type的new 是否存在
- (BOOL)isNewInfoExist:(ContentModel *)model type:(NSString *)type {
    BOOL isExist = NO;
    NSString *sql = @"select * from newsInfo where newId = ? and type = ?";
    FMResultSet *resultSet = [_db executeQuery:sql,model.id,type];
    if (resultSet.next) {
        isExist = YES;
    }
    [resultSet close];
    return isExist;
}

@end
