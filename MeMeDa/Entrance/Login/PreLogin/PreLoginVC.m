
//
//  PreLoginVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/29/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "PreLoginVC.h"
#import "MiPushSDK.h"
#import <RongIMLib/RongIMLib.h>

@interface PreLoginVC ()

@end

@implementation PreLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    NSDictionary *paramDic = @{@"token":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]]};
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getAll" andParam:nil andHeader:paramDic andSuccess:^(id data) {
        [self performSegueWithIdentifier:@"Home" sender:nil];
        NSDictionary *tmpDic = MDUserDic;
        NSString *miAlias = [NSString stringWithFormat:@"%ld",[tmpDic[@"id"] integerValue]];
        [MiPushSDK setAlias:miAlias];
        //RC
        [[RCIMClient sharedRCIMClient] connectWithToken:RCUserToken
            success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%ld", (long)status);
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
        }];
        [SVProgressHUD dismiss];
    } andFailed:^(NSString *str) {
        [self performSegueWithIdentifier:@"Login" sender:nil];
        [SVProgressHUD dismiss]; 
    }];
}


-(void)viewDidAppear:(BOOL)animated{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"]) {
        [self performSegueWithIdentifier:@"Login" sender:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
