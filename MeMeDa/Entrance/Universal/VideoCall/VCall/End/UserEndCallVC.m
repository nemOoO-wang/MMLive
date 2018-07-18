//
//  UserEndCallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UserEndCallVC.h"
#import "NMFloatWindow.h"


@interface UserEndCallVC ()

@end

@implementation UserEndCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickEnd:(id)sender {
    [[NMFloatWindow keyFLoatWindow] dismiss];
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
