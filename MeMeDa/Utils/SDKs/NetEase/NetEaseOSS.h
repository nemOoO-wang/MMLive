//
//  NetEaseOSS.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/29/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOSSDK.h"

@interface NetEaseOSS : NOSUploadManager

+ (instancetype)sharedInstance;

-(void)putFile:(NSString *)path withKey:(NSString *)fileKey result:(NOSUpCompletionHandler)handler;

@end
