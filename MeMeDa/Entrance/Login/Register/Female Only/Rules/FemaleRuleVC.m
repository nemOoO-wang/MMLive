//
//  FemaleRuleVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "FemaleRuleVC.h"


@interface FemaleRuleVC ()
@end

@implementation FemaleRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/specialDescription" andParam:@{@"code":self.searchCode} andSuccess:^(id data) {
        [self.webView loadHTMLString:data[@"data"] baseURL:nil];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

@end
