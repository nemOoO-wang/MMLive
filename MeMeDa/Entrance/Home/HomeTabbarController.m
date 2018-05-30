//
//  HomeTabbarController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/7/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "HomeTabbarController.h"

@interface HomeTabbarController ()

@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *randomBtn;
@property (nonatomic,strong) UIButton *eavesdropBtn;


@end

@implementation HomeTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setTintColor:[UIColor colorWithHexString:@"FF2EB4"]];
    // add custom tabbar
    // self.addBtn layout
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *defautImg = [UIImage imageNamed:@"tab_jia"];
    [self.addBtn setImage:defautImg forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"tab_x"] forState:UIControlStateSelected];
    CGSize barSize = self.tabBar.frame.size;
    self.addBtn.bounds = CGRectMake(0, 0, barSize.height+3, barSize.height+3);
    CGPoint center = self.tabBar.center;
    center.y = barSize.height/2;
    self.addBtn.center = center;
    // self.addBtn event
    [self.addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.addBtn];
    
    // addition btn
    // eaves
    UIButton *eavesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eavesBtn.bounds = CGRectMake(0, 0, 144, 55);
    [eavesBtn setBackgroundColor:[UIColor colorWithHexString:@"FD53F8"]];
    [eavesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [eavesBtn setTitle:@"偷听" forState:UIControlStateNormal];
    [eavesBtn addTarget:self action:@selector(clickEaves) forControlEvents:UIControlEventTouchUpInside];
    eavesBtn.center = CGPointMake(center.x, center.y+50);
    self.eavesdropBtn = eavesBtn;
    
    [self.tabBar addSubview:eavesBtn];
    
    // random
    UIButton *randomCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    randomCallBtn.bounds = CGRectMake(0, 0, 144, 55);
    [randomCallBtn setBackgroundColor:[UIColor colorWithHexString:@"FF5454"]];
    [randomCallBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [randomCallBtn setTitle:@"随机拨号" forState:UIControlStateNormal];
    self.randomBtn = randomCallBtn;
}



- (void)clickAddBtn{
    if ([self.addBtn isSelected]) {
        // selected
        [self.addBtn setSelected:NO];
//        self.tabBarController.presentedViewController;
    }else{
        // unselected
        [self.addBtn setSelected:YES];
    }
}

-(void)clickRandom{
    
}

-(void)clickEaves{
    NSLog(@"dfdfd");
}

@end
