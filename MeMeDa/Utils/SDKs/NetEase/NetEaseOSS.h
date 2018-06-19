//
//  NetEaseOSS.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/29/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOSSDK.h"

typedef void (^NetEaseSuccess)(NSString *urlPath);
typedef void (^NetEaseSuccessArr)(NSArray *urlArr);

@interface NetEaseOSS : NOSUploadManager

+ (instancetype)sharedInstance;

/**
 Nemo: 封装实现版本
 */
-(void)putFile:(NSString *)path withUrlPath:(NSString *)urlPath result:(NetEaseSuccess)success;

/**
 Nemo: 传一张图
 */
-(void)putImage:(UIImage *)img result:(NetEaseSuccess)success;

/**
 Nemo: 传多张图
 */
-(void)putImages:(NSArray *)imgArr result:(NetEaseSuccessArr)success;

/**
 Nemo: 传视频
 */
-(void)putMOV:(NSURL *)contentUrl result:(NetEaseSuccess)success;

/**
 Nemo: 传音频
 */
-(void)putM4A:(NSURL *)contentUrl result:(NetEaseSuccess)success;

/**
 Nemo: 传音频消息
 */
-(void)putWAV:(NSURL *)contentUrl result:(NetEaseSuccess)success;

@end
