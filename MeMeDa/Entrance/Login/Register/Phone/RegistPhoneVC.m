//
//  RegistPhoneVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/28/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "RegistPhoneVC.h"
#import "NMRegTextField.h"


@interface RegistPhoneVC ()
@property (weak, nonatomic) IBOutlet NMRegTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet NMRegTextField *vericodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *veriCodeBtn;

@property (nonatomic,assign) NSInteger countDown;
@property (nonatomic,strong) NSTimer *countDownTimmer;


@end

@implementation RegistPhoneVC

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
    if (self.changePhoneFunc) {
        NSDictionary *parm = @{@"phone":self.phoneTextField.text, @"code":self.vericodeTextField.text};
        [[BeeNet sharedInstance] requestWithType:Request_POST url:@"/chat/user/changeBind" param:parm success:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } fail:^(NSString *message) {
            [SVProgressHUD showErrorWithStatus:@"请确认您的输入"];
        }];
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
