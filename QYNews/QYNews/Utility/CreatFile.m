//
//  CreatFile.m
//  QYNews
//
//  Created by qiaoyan on 15/10/9.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import "CreatFile.h"

@implementation CreatFile
- (id)init {
    if (self = [super init]) {
        [self createLikeFiles];
        [self createUnLikeFiles];
    }
    return self;
}
- (NSString *)cacheFileDirectory {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    cacheDir = [cacheDir stringByAppendingPathComponent:@"QYCache"];
    NSError *error;
    BOOL bret = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&error];
    if (!bret) {
        NSLog(@"%@",error);
        return nil;
    }
    return cacheDir;
}

- (void)createLikeFiles {
    NSString *cacheDir = [self cacheFileDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *likeFilePath = [cacheDir stringByAppendingPathComponent:@"likeFile"];
    
    if (![fileManager fileExistsAtPath:likeFilePath]) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"NFKPlist" ofType:@"plist"];
        if ([fileManager copyItemAtPath:filePath toPath:likeFilePath error:nil]) {
            NSLog(@"success");
        }
    }
}
- (void)createUnLikeFiles {
    NSString *cacheDir = [self cacheFileDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *likeFilePath = [cacheDir stringByAppendingPathComponent:@"unLikeFile"];
    if (![fileManager fileExistsAtPath:likeFilePath]) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"UnLikeQYN" ofType:@"plist"];
        if ([fileManager copyItemAtPath:filePath toPath:likeFilePath error:nil]) {
            NSLog(@"success");
        }
    }
   
}
@end
