//
//  MD5Utils.h
//  MingYa
//
//  Created by 陈必锋 on 2017/10/23.
//  Copyright © 2017年 镓洲 王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface MD5Utils : NSObject

+(NSString*)md5WithString:(NSString*)string;

@end
