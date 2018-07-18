//
//  EavesdropVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/18/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "EavesdropVC.h"

@interface EavesdropVC ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 10人与您一起偷听
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;

@end

@implementation EavesdropVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
