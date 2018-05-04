//
//  FemaleRuleSelVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "FemaleRuleSelVC.h"

@interface FemaleRuleSelVC ()

@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation FemaleRuleSelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArr = @[@"点击查看实名主播相关条款",
                      @"有关聊天金币设置的说明",
                      @"有关金币提现的说明",
                      @"有关预约回拨系统的说明",
                      @"有关主题活动的说明",
                      @"有关第三方偷听模式的说明"];
}


- (IBAction)clickViewDetail:(id)sender {
    UIGestureRecognizer *gesture = sender;
    [self performSegueWithIdentifier:@"detail" sender:self.titleArr[gesture.view.tag-1]];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinVC = [segue destinationViewController];
    destinVC.navigationItem.title = sender;
    [destinVC.navigationItem hidesBackButton];
}


@end
