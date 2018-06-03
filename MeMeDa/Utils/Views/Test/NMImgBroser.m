//
//  NMImgBroser.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMImgBroser.h"

@interface NMImgBroser ()<UIPageViewControllerDataSource>

@end

@implementation NMImgBroser

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
}

# pragma mark - <UIPageViewControllerDataSource>
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([self.imgArr indexOfObject:self.current]==0) {
        return nil;
    }
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.bounds = self.view.bounds;
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(6_0); // The number of items reflected in the page indicator.
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(6_0); // The selected item reflected in the page indicator.

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
