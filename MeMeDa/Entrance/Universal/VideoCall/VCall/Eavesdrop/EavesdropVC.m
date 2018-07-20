//
//  EavesdropVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/18/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "EavesdropVC.h"
#import "EavesdropVC+show.h"


@interface EavesdropVC ()

@end

@implementation EavesdropVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDanmu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickEnd:(id)sender {
    // 退出房间
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickChange:(id)sender {
    // 退出
    // 进入
}


@end
