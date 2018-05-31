//
//  HittestView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "HittestView.h"

@implementation HittestView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        return self;
    }else{
        NSLog(@"navi custom cover init failed");
        return nil;
    }
}

-(instancetype)initInController:(UINavigationController *)controller{
    if (controller.navigationController.view.subviews.count>2) {
        return nil;
    }
    if (self = [self init]) {
        self.mainController = controller;
        controller.navigationController.delegate = self;
        [controller.navigationController.view addSubview:self];
    }
    return self;
}

+(instancetype)hitInController:(UIViewController *)controller with:(NSArray *)views{
    HittestView *view = [[HittestView alloc] initInController:controller];
    view.views = views;
    return view;
}

# pragma mark - <UINavigationControllerDelegate>
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.mainController) {
        return;
    }else{
        [self removeFromSuperview];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView *aView in self.views) {
        CGPoint pointForTargetView = [aView convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(aView.bounds, pointForTargetView)) {
            
            return [aView hitTest:pointForTargetView withEvent:event];
        }
    }
    
    return [super hitTest:point withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
