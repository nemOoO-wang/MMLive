//
//  RegistNewPhoneVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/28/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "RegistNewPhoneVC.h"
#import "NMRegTextField.h"
#import "MD5Utils.h"


@interface RegistNewPhoneVC ()
@property (weak, nonatomic) IBOutlet NMRegTextField *vericodeTextField;
@property (weak, nonatomic) IBOutlet NMRegTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *veriCodeBtn;
@property (weak, nonatomic) IBOutlet NMRegTextField *pswTextField;
@property (weak, nonatomic) IBOutlet NMRegTextField *psw2TextField;
@property (weak, nonatomic) IBOutlet NMRegTextField *inviteCodeTextField;

@property (nonatomic,assign) NSInteger countDown;
@property (nonatomic,strong) NSTimer *countDownTimmer;

@end

@implementation RegistNewPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickGetVeriBtn:(id)sender {
    if (!(self.phoneTextField.text.length == 11)) {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
    }else{
        if ([self.veriCodeBtn.currentTitle isEqualToString:@"获取验证码"]) {
            self.countDown = 60;
            self.countDownTimmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimmer:) userInfo:nil repeats:YES];
            [self.countDownTimmer fire];
            NSDictionary *paramDic = @{@"phone":self.phoneTextField.text};
            [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/getVerification" andParam:paramDic andHeader:nil andSuccess:^(id data) {
                [SVProgressHUD showSuccessWithStatus:@"已发送"];
            } andFailed:^(NSString *str) {
                NSLog(@"%@", str);
            }];
        }        
    }
}

- (void)countDownTimmer:(NSTimer *)timer{
    [self.veriCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%lds)",self.countDown--] forState:UIControlStateNormal];
    if (self.countDown <= 0) {
        [self.veriCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.countDownTimmer invalidate];
    }
}

- (IBAction)clickSubmitBtn:(id)sender {
    if (self.wqParam) {
        NSMutableDictionary *tmpDic = [self.wqParam mutableCopy];
        tmpDic[@"phone"] = self.phoneTextField.text;
        tmpDic[@"pwd"] = [MD5Utils md5WithString:self.pswTextField.text];
        tmpDic[@"inviteCode"] = self.inviteCodeTextField.text;
        tmpDic[@"code"] = self.vericodeTextField.text;
        NSInteger type = [tmpDic[@"loginType"] integerValue];
        self.wqParam = [tmpDic copy];
        [[BeeNet sharedInstance] requestWithType:Request_POST url:@"/chat/user/WXQQRegister" param:self.wqParam success:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            NSDictionary *uDic = data[@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"tmpUserDic"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"qwLoginItems" sender:nil];
        } fail:^(NSString *message) {
        }];
    }else{
        if ([self.pswTextField.text isEqualToString:self.psw2TextField.text]) {
            NSDictionary *regParam = @{@"phone":self.phoneTextField.text, @"pwd":[MD5Utils md5WithString:self.pswTextField.text], @"inviteCode":self.inviteCodeTextField.text, @"code":self.vericodeTextField.text};
            [[NSUserDefaults standardUserDefaults] setObject:regParam forKey:@"regParam"];
            [self performSegueWithIdentifier:@"goon" sender:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"密码不一致"];
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
