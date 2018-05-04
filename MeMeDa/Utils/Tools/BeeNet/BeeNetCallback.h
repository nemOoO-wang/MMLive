//
//  BeeNetCallback.h
//  DingTaiJingRong
//
//  Created by 陈必锋 on 2017/9/4.
//
//

#import <Foundation/Foundation.h>

@interface BeeNetCallback : NSObject

+(BeeNetCallback*)networkWithSuccess:(void(^)(id data))success andFailed:(void(^)(id data))failed;
+(BeeNetCallback*)networkWithOriginSuccess:(void(^)(id data))success andFailed:(void(^)(id data))failed;

-(BOOL)requestResult:(id)data;
-(id)requestSuccessData:(id)data;
-(id)requestFailedData:(id)data;

-(void)requestReturnResult:(id)data;

@end
