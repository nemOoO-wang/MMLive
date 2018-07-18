//
//  HomeTabbarController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/7/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "HomeTabbarController.h"
#import "HomeTabMenuVC.h"


@interface HomeTabbarController ()

@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *randomBtn;
@property (nonatomic,strong) UIButton *eavesdropBtn;
@property (nonatomic,strong) HomeTabMenuVC *menu;


@end

@implementation HomeTabbarController

-(HomeTabMenuVC *)menu{
    if (!_menu) {
        _menu = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SquareMenu"];
        _menu.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _menu.homeAddBtn = self.addBtn;
        __weak typeof(self) weakSelf = self;
        _menu.tabVC = weakSelf;
        // blur cover
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurCover = [[UIVisualEffectView alloc] initWithEffect:effect];
        blurCover.frame = self.view.bounds;
        blurCover.alpha = 0;
        [self.view addSubview:blurCover];
        _menu.homeBlurCover = blurCover;
    }
    return _menu;
}

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
    
}

- (void)clickAddBtn{
    if (![self.addBtn isSelected]) {
        // unselected
        [self.addBtn setSelected:YES];
        //        self.tabBarController.presentedViewController;
        
        [self presentViewController:self.menu animated:YES completion:^{
            
        }];
    }
}


@end
