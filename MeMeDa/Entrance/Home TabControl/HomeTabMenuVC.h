//
//  HomeTabMenuVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/31/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTabbarController.h"


@interface HomeTabMenuVC : UIViewController

@property (nonatomic,strong) UIButton *homeAddBtn;
@property (nonatomic,strong) UIView *homeBlurCover;
@property (nonatomic,weak) HomeTabbarController *tabVC;

@end
