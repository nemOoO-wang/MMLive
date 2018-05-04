//
//  BeeNetCallback.m
//  DingTaiJingRong
//
//  Created by 陈必锋 on 2017/9/4.
//
//

#import "BeeNetCallback.h"

@interface BeeNetCallback ()

@property (strong,nonatomic) void(^success)(id data);
@property (strong,nonatomic) void(^originSuccess)(id data);
@property (strong,nonatomic) void(^failed)(id data);

@end

@implementation BeeNetCallback

+(BeeNetCallback *)networkWithSuccess:(void (^)(id))success andFailed:(void (^)(id))failed{
    BeeNetCallback* cb = [[BeeNetCallback alloc]init];
    cb.success = success;
    cb.failed = failed;
    return cb;
}

+(BeeNetCallback *)networkWithOriginSuccess:(void (^)(id))success andFailed:(void (^)(id))failed{
    BeeNetCallback* cb = [[BeeNetCallback alloc]init];
    cb.originSuccess = success;
    cb.failed = failed;
    return cb;
}

-(BOOL)requestResult:(id)data {
    if ([data[@"ret"] boolValue]) {
        if (data[@"data"] == [NSNull null]) {
            return NO;
        }
        return YES;
    }else{
        if ([data[@"forUser"] isEqualToString:@"登陆无效请重新登录"]) {
            [SVProgressHUD showErrorWithStatus:data[@"forUser"]];
            [SVProgressHUD dismissWithDelay:2 completion:^{
                [[UIApplication sharedApplication].delegate.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PreLoginViewController"]];
            }];
        }
        return NO;
    }
}

-(id)requestSuccessData:(id)data {
    return data[@"data"];
}

-(id)requestFailedData:(id)data {
    if (data[@"data"] == [NSNull null]) {
        return @"加载数据失败";
    }
    return data[@"forUser"];
}

-(void)requestReturnResult:(id)data {
    if ([self requestResult:data]) {
        if (self.success != nil) {
            self.success([self requestSuccessData:data]);
        }else{
            self.originSuccess(data);
        }
        
    }else {
        self.failed([self requestFailedData:data]);
    }
}
@end
