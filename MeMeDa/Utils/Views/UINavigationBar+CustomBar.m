//
//  UINavigationBar+CustomBar.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UINavigationBar+CustomBar.h"

@implementation UINavigationBar (CustomBar)

-(void)didMoveToSuperview{
    self.translucent = YES;
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor whiteColor];
    self.barTintColor = [UIColor whiteColor];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.shadowImage = [UIImage new];
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

@end
