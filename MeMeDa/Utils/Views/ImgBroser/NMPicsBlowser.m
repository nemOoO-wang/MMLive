//
//  NMPicsBlowser.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMPicsBlowser.h"
#import "UIWindow+NMCurrent.h"
#import "NMImgBroser.h"


@interface NMPicsBlowser()

@end


@implementation NMPicsBlowser

-(void)setUpWith:(NSArray *)imgArr and:(NSInteger)index{
    if (imgArr) {
        UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] getCurrentViewController];
        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:10] forKey:UIPageViewControllerOptionInterPageSpacingKey];
        NMImgBroser *pre = [[NMImgBroser alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
        pre.imgArr = imgArr;
        pre.index = index;
        pre.arrType = ImgTypeUrl;
        [vc.navigationController pushViewController:pre animated:YES];
    }
}


-(void)layoutSubviews{
    self.userInteractionEnabled = YES;
    // tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBrowser)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    // long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteThis:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
}


-(void)showBrowser{
    NSLog(@"tap");
    if (self.browser) {
        self.browser();
    }
}

-(void)deleteThis:(UILongPressGestureRecognizer *)gesture{
//    NSLog(@"leisure");
    if (gesture.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"delte");
    }
    else if (gesture.state == UIGestureRecognizerStateBegan){
        if (self.deletion) {
            self.deletion();
        }
    }
}

-(void)setRawImg:(UIImage *)img withBrowser:(void (^)(NMPicsBlowser *obj))browser delete:(void (^)(void))deletion{
    [super setImage:img];
    __weak typeof(self) weakSelf = self;
    self.browser = ^{
        browser(weakSelf);
    };
    self.deletion = ^{
        if (deletion) {
            deletion();
        }
    };
}

-(void)setImg:(NSString *)img withBrowser:(void (^)(NMPicsBlowser *obj))browser delete:(void (^)(void))deletion{
    NSURL *url = [NSURL URLWithString:img];
    [self sd_setImageWithURL:url];
    __weak typeof(self) weakSelf = self;
    self.browser = ^{
        browser(weakSelf);
    };
    self.deletion = ^{
        if (deletion) {
            deletion();
        }
    };
}

@end
