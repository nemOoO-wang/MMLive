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
#import "RegistInfoVC.h"
#import "SHA1Utils.h"
#import "MiPushSDK.h"
#import <NIMSDK/NIMSDK.h>
#import "NMFloatWindow.h"
#import <RongCloudIM/RongIMLib/RongIMLib.h>


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet NMRegTextField *phoneTF;
@property (weak, nonatomic) IBOutlet NMRegTextField *pswTF;
@property (nonatomic,strong) UIViewController *vc;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickLogin:(id)sender {
    NSDictionary *paramDic = @{@"phone":self.phoneTF.text, @"pwd":[MD5Utils md5WithString:self.pswTF.text], @"loginType":@3};
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/login" andParam:paramDic andHeader:nil andSuccess:^(id data) {
        [self LoginwithData:data];
        // 维护好友列表
        [self initFriendList];
    } andFailed:^(NSString *str) {
        NSLog(@"str");
    }];
}

-(void)initFriendList{
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/friendMsg" andParam:nil andSuccess:^(id data) {
        NSArray *friendArr = data[@"data"];
        NSMutableArray *orderedChat = [[NSMutableArray alloc] init];
        [friendArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [orderedChat addObject:@[obj, @""]];
        }];
        [[NSUserDefaults standardUserDefaults] setObject:[orderedChat copy] forKey:@"Friend Chat"];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"Friend Unread"];
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
             // 注册
             NSDictionary *param = @{@"headImg":user.icon, @"nickname": user.nickname, @"qqOpenId": user.uid, @"loginType":@1};
             [self handleWQParam:param];
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
             // 注册
             NSDictionary *param = @{@"headImg":user.icon, @"nickname": user.nickname, @"wxOpenId": user.uid, @"loginType":@2};
             [self handleWQParam:param];
         }
         else{
             NSLog(@"%@",error);
         }
     }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"qwLogin"]) {
        RegistInfoVC *vc = segue.destinationViewController;
        vc.wqParam = (NSDictionary *)sender;
    }
}

-(void)LoginwithData:(id)data{
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    // 清除之前的 mi account
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    if (dic) {
        NSString *acid = [dic[@"id"] stringValue];
        [MiPushSDK unsetAccount:acid];
    }
    [[NSUserDefaults standardUserDefaults] setObject:data[@"data"][@"token"] forKey:@"token"];
    NSDictionary *uDic = data[@"data"];
    
    NSMutableDictionary *tmpDic = [uDic mutableCopy];
    [tmpDic removeObjectForKey:@"verifies"];
    uDic = [tmpDic copy];
    
    // 包含 NSNull 后期可能需要处理
    [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"UserData"];
    NSString *token = data[@"data"][@"token"];
    // 小米 alias
    NSString *miAlias = [NSString stringWithFormat:@"%ld",[uDic[@"id"] integerValue]];
    //        [MiPushSDK setAlias:miAlias];
    [MiPushSDK setAccount:miAlias];
    // 网易 im 登录
    [[NSUserDefaults standardUserDefaults] setObject:uDic[@"easyId"] forKey:@"NEAccount"];
    [[NSUserDefaults standardUserDefaults] setObject:uDic[@"easyToken"] forKey:@"NEToken"];
    [[[NIMSDK sharedSDK] loginManager] login:NEUserAccount token:NEUserToken completion:^(NSError * _Nullable error) {
        NSLog(@"%@",error.description);
    }];
    // 融云token
    // body
    NSDictionary *rcDic;
    if(uDic[@"headImg"]){
        rcDic = @{@"name":uDic[@"nickname"], @"userId":uDic[@"id"], @"portraitUri":uDic[@"headImg"]};
    }else{
        rcDic = @{@"name":uDic[@"nickname"], @"userId":uDic[@"id"], @"portraitUri":@"http://asset.nos-eastchina1.126.net/Imgs/%E2%AD%90%EF%B8%8FOrigin/GTA%20%E5%BC%A0%E5%AD%A6%E5%8F%8B.jpg"};
    }
    // RC: 请求 token
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
        // RC 根据 token 注册
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
    } andFailed:^(NSString *str) {
        NSLog(@"融云：%@",str);
    }];
    // 跳转
    [self performSegueWithIdentifier:@"home" sender:nil];
}

-(void)handleWQParam:(NSDictionary *)param{
    NSInteger type = [param[@"loginType"] integerValue];
    NSString *uid = type==2? param[@"wxOpenId"]: param[@"qqOpenId"];
    NSDictionary *paramDic = @{@"type":param[@"loginType"], @"openId":uid};
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/isExist" andParam:paramDic andSuccess:^(id data) {
        BOOL exist = [data[@"data"] boolValue];
        if (exist) {
            // 直接登录
            NSString *idKey = type==2? @"wxOpenId": @"qqOpenId";
            NSString *idValue = uid;
            NSDictionary *paramDic2 = @{@"loginType":param[@"loginType"], idKey: idValue};
            [[BeeNet sharedInstance] requestWithType:Request_POST url:@"/chat/user/login" param:paramDic2 success:^(id data) {
                [self LoginwithData:data];
            } fail:^(NSString *message) {
            }];
        }else{
            // 新用户
            [self performSegueWithIdentifier:@"qwLogin" sender:param];
        }
    }];
}

@end
