//
//  MD5Utils.m
//  MingYa
//
//  Created by 陈必锋 on 2017/10/23.
//  Copyright © 2017年 镓洲 王. All rights reserved.
//

#import "MD5Utils.h"

@implementation MD5Utils

+(NSString *)md5WithString:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr) , digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
