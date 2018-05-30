//
//  NetEaseOSS.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/29/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//
// https://www.163yun.com/help/documents/15665140818739200

#import "NetEaseOSS.h"


@implementation NetEaseOSS

+ (instancetype)sharedInstance
{
    static NetEaseOSS *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 建议使用下面的单例模式创建NOSUloadManager实例，创建完后只使用该实例，无需再创建
        sharedInstance = [NetEaseOSS sharedInstanceWithRecorder:nil recorderKeyGenerator:nil];
        NOSConfig *conf = [[NOSConfig alloc] init];
        [NOSUploadManager setGlobalConf:conf];
        sharedInstance.token = @"从应用服务端获取";
    });
    return sharedInstance;
}

/**
 封装实现版本
 */
-(void)putFile:(NSString *)path withKey:(NSString *)key result:(NOSUpCompletionHandler)handler{
    // 使用http上传，如果用htts，使用putFileByHttps函数即可
    [self putFileByHttp: @"filePath"
                      bucket: @"mybucket"
                         key: @"exclusiveName.jpg"
                       token: self.token
                    complete: ^(NOSResponseInfo *info, NSString *key, NSDictionary *resp) {
                        NSLog(@"%@", info); // 请求的响应信息、是否出错保存在info中
                        NSLog(@"%@", resp); // 请求的响应返回的json保存在resp中，用户一般无需此信息
                        handler(info, key, resp);
                    }
                    option: nil];
}


@end
