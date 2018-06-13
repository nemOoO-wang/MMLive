//
//  SHA1Utils.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/13/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface SHA1Utils : NSObject

+(NSString*)SHA1WithString:(NSString*)string;

@end
