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

@property (nonatomic,strong) NSString *token;

+ (instancetype)sharedInstance;



@end
