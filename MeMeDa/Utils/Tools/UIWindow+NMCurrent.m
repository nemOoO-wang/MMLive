//
//  UIWindow+NMCurrent.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UIWindow+NMCurrent.h"

@implementation UIWindow (NMCurrent)

-(UIViewController *)getCurrentViewController{
    // top most
    UIViewController *root = [self rootViewController];
    while ([root presentedViewController])
        root = [root presentedViewController];
    // get current
    while ([root isKindOfClass:[UINavigationController class]] || [root isKindOfClass:[UITabBarController class]]) {
        if ([root isKindOfClass:[UINavigationController class]]) {
            root = [(UINavigationController *)root topViewController];
        }
        else if ([root isKindOfClass:[UITabBarController class]]){
            root = [(UITabBarController *)root selectedViewController];
        }
    }
    return root;
}

@end
