//
//  HittestView.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 在 viewDidAppear 中 init 并且赋值需要传递的 views 数组
 */
@interface HittestView : UIView<UINavigationControllerDelegate>

@property (nonatomic,strong) NSArray *views;
@property (nonatomic,strong) UIViewController *mainController;

/**
 在 viewDidAppear 中 init 并且赋值需要传递的 views 数组
 */
-(instancetype)initInController:(UIViewController *)controller;

@end
