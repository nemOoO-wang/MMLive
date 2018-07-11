//
//  ChooseRoleVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ChooseRoleVC.h"
#import "VCallVC.h"


@interface ChooseRoleVC ()

@end

@implementation ChooseRoleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickAnchor:(id)sender {
    [self performSegueWithIdentifier:@"choose" sender:@"Anchor"];
}
- (IBAction)clickUser:(id)sender {
    [self performSegueWithIdentifier:@"choose" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isEqualToString:@"Anchor"]) {
        VCallVC *vc = segue.destinationViewController;
        vc.userType = CallUserAnchor;
    }else{
        VCallVC *vc = segue.destinationViewController;
        vc.userType = CallUserDefault;
        vc.callingAnchorId = @"47";
    }
}


@end
