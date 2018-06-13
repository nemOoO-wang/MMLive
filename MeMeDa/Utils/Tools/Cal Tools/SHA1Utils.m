//
//  SHA1Utils.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/13/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SHA1Utils.h"

@implementation SHA1Utils

+(NSString*)SHA1WithString:(NSString*)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
