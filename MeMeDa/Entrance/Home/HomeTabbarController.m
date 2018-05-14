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
    self.addBtn.frame = CGRectMake(0, 0, defautImg.size.width, defautImg.size.height);
    CGSize barSize = self.tabBar.frame.size;
    CGFloat offset = defautImg.size.height - barSize.height;
    CGPoint center = self.tabBar.center;
    center.y = (barSize.height)/2 - offset;
    self.addBtn.center = center;
    // self.addBtn event
    [self.addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.addBtn];
}


- (void)clickAddBtn{
    if ([self.addBtn isSelected]) {
        // selected
        [self.addBtn setSelected:NO];
    }else{
        // unselected
        [self.addBtn setSelected:YES];
    }
}


@end
