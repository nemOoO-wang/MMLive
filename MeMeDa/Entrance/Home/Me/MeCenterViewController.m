//
//  MeCenterViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MeCenterViewController.h"
#import "HittestView.h"

@interface MeCenterViewController ()
@property (nonatomic,strong) HittestView *hittestView;

@property (weak, nonatomic) IBOutlet UIButton *ComposeBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

@end

@implementation MeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.hittestView removeFromSuperview];
}
-(void)viewDidAppear:(BOOL)animated{
    self.hittestView = [[HittestView alloc] initInController:self];
    self.hittestView.views = @[self.ComposeBtn, self.settingBtn];
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
            [self performSegueWithIdentifier:@"new moment" sender:nil];
            break;
            
        default:
            break;
    }
}
- (IBAction)clickFollow:(id)sender {
    UIGestureRecognizer *rcg = sender;
    UIView *view = rcg.view;
    switch (view.tag) {
        case 10:
            [self performSegueWithIdentifier:@"follower" sender:nil];
            break;
        case 11:
            [self performSegueWithIdentifier:@"follower" sender:nil];
            break;
            
        default:
            break;
    }
}


@end
