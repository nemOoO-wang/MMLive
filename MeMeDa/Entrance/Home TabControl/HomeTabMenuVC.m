//
//  HomeTabMenuVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/31/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "HomeTabMenuVC.h"
#import "NMLoginButton.h"
#import <Masonry.h>


@interface HomeTabMenuVC ()
@property (weak, nonatomic) IBOutlet NMLoginButton *randomBtn;
@property (weak, nonatomic) IBOutlet NMLoginButton *eavesBtn;

@end

@implementation HomeTabMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // btn shadow
    // eavesdrop
    UIView *eShadow = [[UIView alloc] init];
    [eShadow setBackgroundColor:[UIColor colorWithHexString:@"FD53F8"]];
    CALayer *eavesLayer = eShadow.layer;
    eavesLayer.shadowColor = [UIColor colorWithHexString:@"FD53F8"].CGColor;
    eavesLayer.cornerRadius = 27.5;
    eavesLayer.shadowRadius = 10;
    eavesLayer.shadowOffset = CGSizeZero;
    eavesLayer.shadowOpacity = 1;
    [self.view insertSubview:eShadow belowSubview:self.eavesBtn];
    [eShadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self.eavesBtn);
    }];
    //random
    UIView *rShadow = [[UIView alloc] init];
    [rShadow setBackgroundColor:[UIColor colorWithHexString:@"FF5454"]];
    CALayer *randomLayer = rShadow.layer;
    randomLayer.shadowColor = [UIColor colorWithHexString:@"FF5454"].CGColor;
    randomLayer.cornerRadius = 27.5;
    randomLayer.shadowRadius = 10;
    randomLayer.shadowOffset = CGSizeZero;
    randomLayer.shadowOpacity = 1;
    [self.view insertSubview:rShadow belowSubview:self.randomBtn];
    [rShadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self.randomBtn);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [UIView animateWithDuration:0.4 animations:^{
        self.homeBlurCover.alpha = 0.3;
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIView animateWithDuration:0.3 animations:^{
        self.homeBlurCover.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.homeAddBtn setSelected:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
