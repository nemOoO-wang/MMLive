//
//  FileUtils.m
//  MingYa
//
//  Created by 陈必锋 on 2017/10/23.
//  Copyright © 2017年 镓洲 王. All rights reserved.
//

#import "FileUtils.h"
#import "MD5Utils.h"

@implementation FileUtils

+(NSString *)filePathWithFileName:(NSString *)fileUrl andFileName:(NSString*)fileName{
    NSString *caches = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectFile"];
    caches = [caches stringByAppendingPathComponent:[MD5Utils md5WithString:[NSString stringWithFormat:@"%@%@",fileUrl,fileName]]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:caches]) {
        [fileManager createDirectoryAtPath:caches withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //根据名称大小md5,作为文件名
    NSString * filePath = [caches stringByAppendingPathComponent:fileName];
    return filePath;
}

@end
