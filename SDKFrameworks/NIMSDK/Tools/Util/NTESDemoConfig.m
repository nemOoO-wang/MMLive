//
//  NTESDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDemoConfig.h"

@interface NTESDemoConfig ()

@end

@implementation NTESDemoConfig
+ (instancetype)sharedConfig
{
    static NTESDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _appKey = @"32dd6ad20f8b1757e1c19b499874818a";
        _apiURL = @"https://app.netease.im/api";
    }
    return self;
}

- (NSString *)appKey
{
    return _appKey;
}

- (NSString *)apiURL
{
    return _apiURL;
}

- (NSString *)cerName
{
    return nil;
}


@end
