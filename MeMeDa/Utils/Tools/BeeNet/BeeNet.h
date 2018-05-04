//
//  BeeNet.h
//  ShopDog
//
//  Created by 陈必锋 on 2017/8/4.
//  Copyright © 2017年 shopDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeeNetCallback.h"

typedef NS_ENUM(NSInteger,RequestType){
    Request_GET,
    Request_POST,
    Request_PUT,
    Request_Delete
};

@interface BeeNet : NSObject

+(instancetype)sharedInstance;

-(void)requestWithType:(RequestType)requestType andUrl:(NSString*)url andParam:(id)params andHeader:(NSDictionary*)header andRequestSerializer:(id)requestSer andResponseSerializer:(id)responseSer andSuccess:(void(^)(id data))success andFailed:(void(^)(NSString* str))failed;

-(void)requestWithType:(RequestType)requestType andUrl:(NSString*)url andParam:(id)params andHeader:(NSDictionary*)header andSuccess:(void(^)(id data))success andFailed:(void(^)(NSString* str))failed;


-(void)requestWithType:(RequestType)requestType andUrl:(NSString*)url andParam:(id)params andHeader:(NSDictionary*)header andBeeCallBack:(BeeNetCallback*)beeCallback;


-(void)postFileWithUrl:(NSString*)url andFileKey:(NSString*)fileKey andParams:(id)param andFileData:(NSData*)FileData andHeader:(NSDictionary *)header andBeeCallback:(BeeNetCallback*)beeCallback;


-(void)headRequest:(NSString*)url andSuccess:(void(^)(id data))success andFailed:(void(^)(NSString* str))failed;
@end
