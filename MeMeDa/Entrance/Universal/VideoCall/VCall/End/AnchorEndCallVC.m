//
//  AnchorEndCallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "AnchorEndCallVC.h"
#import "NMFloatWindow.h"


@interface AnchorEndCallVC ()

@end

@implementation AnchorEndCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickEnd:(id)sender {
    if (self.audioCall) {
//        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"End Audio Call" object:nil userInfo:nil];
    }else{
        [[NMFloatWindow keyFLoatWindow] dismiss];
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
