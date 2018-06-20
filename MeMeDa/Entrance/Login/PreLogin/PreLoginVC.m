
//
//  PreLoginVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/29/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "PreLoginVC.h"
#import "MiPushSDK.h"

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
