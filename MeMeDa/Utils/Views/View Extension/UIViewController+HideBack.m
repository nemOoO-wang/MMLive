//
//  UIViewController+HideBack.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UIViewController+HideBack.h"

@implementation UIViewController (HideBack)

//-(void)viewDidLoad{
//    [super viewDidLoad];
//    
//}

-(void)didMoveToParentViewController:(UIViewController *)parent{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

@end
