//
//  UserInfoPopMenuVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UserInfoPopMenuVC.h"

@interface UserInfoPopMenuVC ()

@end

@implementation UserInfoPopMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(void)didsmissSelf{
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = 0;
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickLaHei:(id)sender {
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/black" andParam:@{@"userId":self.uid} andSuccess:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        [self didsmissSelf];
    }];
}

- (IBAction)clickJuBao:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"举报用户" message:@"请输入举报信息" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"请输入举报信息"];
    }];
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 提交
        NSString *str = alertVC.textFields.firstObject.text;
        if (!str) {
            str = @"";
        }
        [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/report" andParam:@{@"reason":str, @"userId":self.uid} andSuccess:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:act1];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)clickFenXiang:(id)sender {
}

- (IBAction)didClickCancel:(id)sender {
    [self didsmissSelf];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self didsmissSelf];
//}

@end
