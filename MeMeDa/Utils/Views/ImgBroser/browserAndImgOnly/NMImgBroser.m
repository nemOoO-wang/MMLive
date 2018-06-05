//
//  NMImgBroser.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMImgBroser.h"
#import "ImageOnlyController.h"
#import <UIImageView+WebCache.h>


@interface NMImgBroser ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic,assign) NSInteger tmpIndex;

@end

@implementation NMImgBroser

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    [self.view setBackgroundColor:[UIColor blackColor]];
    // init vc
    ImageOnlyController *vc;
    if (self.arrType == ImgTypeUrl) {
        vc = [ImageOnlyController controllerWithImageUrl:self.imgArr[self.index] andIndex:self.index];
    }else{
        vc = [ImageOnlyController controllerWithImage:self.imgArr[self.index] andIndex:self.index];
    }
    [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    }];
}

# pragma mark - <UIPageViewControllerDataSource>
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if (!self.imgArr) {
        return nil;
    }
    if (self.index==0) {
        return nil;
    }
    ImageOnlyController *vc;
    if (self.arrType == ImgTypeUrl) {
        vc = [ImageOnlyController controllerWithImageUrl:self.imgArr[self.index-1] andIndex:self.index-1];
    }else{
        vc = [ImageOnlyController controllerWithImage:self.imgArr[self.index-1] andIndex:self.index-1];
    }
    return vc;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if (!self.imgArr) {
        return nil;
    }
    if (self.index >= self.imgArr.count-1) {
        return nil;
    }
    ImageOnlyController *vc;
    if (self.arrType == ImgTypeUrl) {
        vc = [ImageOnlyController controllerWithImageUrl:self.imgArr[self.index+1] andIndex:self.index+1];
    }else{
        vc = [ImageOnlyController controllerWithImage:self.imgArr[self.index+1] andIndex:self.index+1];
    }
    return vc;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return self.imgArr.count;
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return self.index;
}

# pragma mark - <delegate>
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    ImageOnlyController *vc = pendingViewControllers[0];
    self.tmpIndex = vc.index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        self.index = self.tmpIndex;
        NSLog(@"%ld",self.index);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
