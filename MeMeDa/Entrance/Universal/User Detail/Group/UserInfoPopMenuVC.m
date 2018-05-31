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

- (IBAction)didClickCancel:(id)sender {
    [self didsmissSelf];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self didsmissSelf];
}

@end
