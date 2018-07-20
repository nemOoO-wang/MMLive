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
//    self.translucent = YES;
    self.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor colorWithHexString:@"494949"];
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
    self.tintColor = [UIColor whiteColor];
    self.barTintColor = [UIColor whiteColor];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}


@end
