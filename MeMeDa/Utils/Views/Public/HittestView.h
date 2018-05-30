//
//  HittestView.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 在 viewDidAppear 中赋值主 VC、传递 views 数组
 */
@interface HittestView : UIView<UINavigationControllerDelegate>

@property (nonatomic,strong) NSArray *views;
@property (nonatomic,strong) UIViewController *mainController;

/**
 在 viewDidAppear 中赋值主 VC、传递 views 数组
 */
-(instancetype)initInController:(UIViewController *)controller;

+(instancetype)hitInController:(UIViewController *)controller with:(NSArray *)views;

@end
