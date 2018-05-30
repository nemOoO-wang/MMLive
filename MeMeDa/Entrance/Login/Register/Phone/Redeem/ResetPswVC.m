//
//  ResetPswVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/29/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ResetPswVC.h"
#import "MD5Utils.h"


@interface ResetPswVC ()

@property (weak, nonatomic) IBOutlet NMRegTextField *vericodeTextField;
@property (weak, nonatomic) IBOutlet NMRegTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *veriCodeBtn;
@property (weak, nonatomic) IBOutlet NMRegTextField *pswTextField;
@property (weak, nonatomic) IBOutlet NMRegTextField *psw2TextField;

@property (nonatomic,assign) NSInteger countDown;
@property (nonatomic,strong) NSTimer *countDownTimmer;

@end

@implementation ResetPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickGetVeriBtn:(id)sender {
    if ([self.veriCodeBtn.currentTitle isEqualToString:@"获取验证码"]) {
        self.countDown = 60;
        self.countDownTimmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimmer:) userInfo:nil repeats:YES];
        [self.countDownTimmer fire];
        NSDictionary *paramDic = @{@"phone":self.phoneTextField.text};
        [[BeeNet sharedInstance] requestWithType:Request_POST
          andUrl:@"/chat/user/getVerification" andParam:paramDic andHeader:nil andSuccess:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"已发送"];
        } andFailed:nil];
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
    if ([self.pswTextField.text isEqualToString:self.psw2TextField.text]) {
        NSDictionary *regParam = @{@"phone":self.phoneTextField.text, @"pwd":[MD5Utils md5WithString:self.pswTextField.text], @"code":self.vericodeTextField.text};
        [[BeeNet sharedInstance] requestWithType:Request_POST
          andUrl:@"/chat/user/forgetPwd" andParam:regParam
           andHeader:nil andSuccess:^(id data) {
               [self.navigationController popToRootViewControllerAnimated:YES];
           } andFailed:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"密码不一致"];
    }
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
