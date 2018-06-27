//
//  LoginViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <AFNetworking.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MD5Utils.h"
#import "SHA1Utils.h"
#import "MiPushSDK.h"
#import <NIMSDK/NIMSDK.h>
#import "NMFloatView.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet NMRegTextField *phoneTF;
@property (weak, nonatomic) IBOutlet NMRegTextField *pswTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // window float view
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NMFloatView *vcallView = [[NMFloatView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [vcallView setBackgroundColor:[UIColor redColor]];
    [window addSubview:vcallView];
    [window bringSubviewToFront:vcallView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickLogin:(id)sender {
    NSDictionary *paramDic = @{@"phone":self.phoneTF.text, @"pwd":[MD5Utils md5WithString:self.pswTF.text], @"loginType":@3};
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/login" andParam:paramDic andHeader:nil andSuccess:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [[NSUserDefaults standardUserDefaults] setObject:data[@"data"][@"token"] forKey:@"token"];
        NSDictionary *uDic = data[@"data"];
        // 小米 alias
        NSString *miAlias = [NSString stringWithFormat:@"%ld",[uDic[@"id"] integerValue]];
        [MiPushSDK setAlias:miAlias];
        // 网易 im 登录
        [[NSUserDefaults standardUserDefaults] setObject:uDic[@"easyId"] forKey:@"NEAccount"];
        [[NSUserDefaults standardUserDefaults] setObject:uDic[@"easyToken"] forKey:@"NEToken"];
        [[[NIMSDK sharedSDK] loginManager] login:NEUserAccount token:NEUserToken completion:^(NSError * _Nullable error) {
            NSLog(@"%@",error.description);
        }];
        [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"UserData"];
        [self performSegueWithIdentifier:@"home" sender:nil];
        // 融云token
        // body
        NSDictionary *rcDic;
        if(uDic[@"headImg"]){
            rcDic = @{@"name":uDic[@"nickname"], @"userId":uDic[@"id"], @"portraitUri":uDic[@"headImg"]};
        }else{
            rcDic = @{@"name":uDic[@"nickname"], @"userId":uDic[@"id"], @"portraitUri":@"http://asset.nos-eastchina1.126.net/Imgs/%E2%AD%90%EF%B8%8FOrigin/GTA%20%E5%BC%A0%E5%AD%A6%E5%8F%8B.jpg"};
        }
        // header
        NSString *appKey = RCAPPKey;
        NSString *appSecret = RCAPPSecret;
        uint nounce = arc4random();
        NSInteger timestrap = [[NSDate date] timeIntervalSince1970];
        NSString *signature = [SHA1Utils SHA1WithString:[NSString stringWithFormat:@"%@%d%ld",appSecret,nounce,timestrap]];
        NSDictionary *headerDic = @{@"App-Key":appKey,
                                    @"Nonce":[NSString stringWithFormat:@"%d",nounce],
                                    @"Timestamp":[NSString stringWithFormat:@"%ld",timestrap],
                                    @"Signature":signature};
        [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"http://api.cn.ronghub.com/user/getToken.json" andParam:rcDic andHeader:headerDic andSuccess:^(id data) {
            [[NSUserDefaults standardUserDefaults] setObject:data[@"token"] forKey:@"RCToken"];
        } andFailed:^(NSString *str) {
            NSLog(@"融云：%@",str);
        }];
    } andFailed:^(NSString *str) {
        NSLog(@"str");
    }];
}


- (IBAction)clickQQLodin:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         else{
             NSLog(@"%@",error);
         }
     }];
}
- (IBAction)clickWXLogin:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         else{
             NSLog(@"%@",error);
         }
     }];
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
