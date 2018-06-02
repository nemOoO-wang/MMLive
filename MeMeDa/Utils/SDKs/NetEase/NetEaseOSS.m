//
//  NetEaseOSS.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/29/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//
// https://www.163yun.com/help/documents/15665140818739200

#import "NetEaseOSS.h"
#import "NOSTokenUtils.h"


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
    });
    return sharedInstance;
}

/**
 Nemo 封装实现版本
 */
-(void)putFile:(NSString *)path withUrlPath:(NSString *)urlPath result:(NetEaseSuccess)success{
    
    // gen token
    NSString *token = [NOSTokenUtils genTokenWithBucket:@"asset"
                              withKey:urlPath
                           withElipse:1000
                        withAccessKey:@"2a7c38e666cf4079a0dd0ffe66e3dfb5"
                        withSecretKey:@"d2299bf5e9584583ab4a52c216f2f78a"];
    
    // 使用http上传，如果用htts，使用putFileByHttps函数即可
    [self putFileByHttp: path
                      bucket: @"asset"
                         key: urlPath
                       token: token
                    complete: ^(NOSResponseInfo *info, NSString *key, NSDictionary *resp) {
                        NSLog(@"%@", info); // 请求的响应信息、是否出错保存在info中
                        NSLog(@"%@", resp); // 请求的响应返回的json保存在resp中，用户一般无需此信息
                        success([NSString stringWithFormat:@"http://asset.nos-eastchina1.126.net/%@",urlPath]);
                    }
                    option: nil];
}

-(NSNumber *)getUID{
    NSDictionary *uInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    return uInfo[@"id"];
}

-(NSString *)getCurrent{
    NSDate *current = [NSDate date];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy-MM-dd_HH_mm_ss"];
    return [fm stringFromDate:current];
}

-(void)putImage:(UIImage *)img result:(NetEaseSuccess)success{
    NSNumber *userID = [self getUID];
    // gen img name (.jpg)
    NSString *fileKey = [NSString stringWithFormat:@"%@.jpg",[self getCurrent]];
    // img 2 local tmp path
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:fileKey];
    NSData *imgData = UIImageJPEGRepresentation(img, 0.4);
    [imgData writeToFile:path atomically:NO];
    // url path
    NSString *urlPath = [NSString stringWithFormat:@"Imgs/%ld/%@",[userID integerValue], fileKey];
    // push
    [[NetEaseOSS sharedInstance] putFile:path withUrlPath:urlPath result:^(NSString *urlPath) {
        success(urlPath);
    }];
}

-(void)putImages:(NSArray *)imgArr result:(NetEaseSuccessArr)success{
    NSNumber *userID = [self getUID];
    NSInteger iaIndex = 0;
    // tmp fle name
    NSString *current = [self getCurrent];
    __block NSMutableArray *urlArr = [[NSMutableArray alloc] init];
    for (UIImage *img in imgArr) {
        NSString *fileKey = [NSString stringWithFormat:@"%@%ld.jpg",current, iaIndex++];
        // img 2 local tmp path
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:fileKey];
        NSData *imgData = UIImageJPEGRepresentation(img, 0.4);
        [imgData writeToFile:path atomically:NO];
        // url path
        NSString *urlPath = [NSString stringWithFormat:@"Imgs/%ld/%@",[userID integerValue], fileKey];
        // push
        [[NetEaseOSS sharedInstance] putFile:path withUrlPath:urlPath result:^(NSString *urlPath) {
            [urlArr addObject:urlPath];
            if (urlArr.count == imgArr.count) {
                success([urlPath copy]);
            }
        }];
    }
}

-(void)putMOV:(NSURL *)contentUrl result:(NetEaseSuccess)success{
    NSNumber *userID = [self getUID];
    // gen img name (.jpg)
    NSString *fileKey = [NSString stringWithFormat:@"%@.mov",[self getCurrent]];
    // img 2 local tmp path
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:fileKey];
    NSData *movData = [NSData dataWithContentsOfURL:contentUrl];
    [movData writeToFile:path atomically:NO];
    // url path
    NSString *urlPath = [NSString stringWithFormat:@"Imgs/%ld/%@",[userID integerValue], fileKey];
    // push
    [[NetEaseOSS sharedInstance] putFile:path withUrlPath:urlPath result:^(NSString *urlPath) {
        success(urlPath);
    }];
}


@end
