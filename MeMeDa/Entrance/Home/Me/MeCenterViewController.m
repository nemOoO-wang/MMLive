//
//  MeCenterViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MeCenterViewController.h"

@interface MeCenterViewController ()

@end

@implementation MeCenterViewController

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

# pragma mark - Click Btn

- (IBAction)clickMetroBtn:(id)sender {
    UIGestureRecognizer *gesture = sender;
    UIView *view = gesture.view;
    switch (view.tag) {
        case 3:
            [self performSegueWithIdentifier:@"Theme" sender:nil];
            break;
        case 4:
            [self performSegueWithIdentifier:@"Moment" sender:nil];
            break;
        case 5:
            [self performSegueWithIdentifier:@"new moment" sender:nil];
            break;
            
        default:
            break;
    }
}

@end
