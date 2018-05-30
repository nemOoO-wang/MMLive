//
//  LoginViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MD5Utils.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet NMRegTextField *phoneTF;
@property (weak, nonatomic) IBOutlet NMRegTextField *pswTF;

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
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [[NSUserDefaults standardUserDefaults] setObject:data[@"data"] forKey:@"UserData"];
        [[NSUserDefaults standardUserDefaults] setObject:data[@"data"][@"token"] forKey:@"token"];
        [self performSegueWithIdentifier:@"home" sender:nil];
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
