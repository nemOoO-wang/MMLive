//
//  NMPicsBlowser.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMPicsBlowser.h"
#import "UIWindow+NMCurrent.h"


@interface NMPicsBlowser()

@end


@implementation NMPicsBlowser

-(void)setImgArr:(NSArray *)imgArr{
    _imgArr = imgArr;
    if ([imgArr containsObject:self.image]) {
        // call out
//        [[[UIApplication sharedApplication] keyWindow] rootViewController]
        UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] getCurrentViewController];
        UIViewController *pre = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"test"];
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
    longPress.minimumPressDuration = 1.0;
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

-(void)setImg:(UIImage *)img withBrowser:(void (^)(NMPicsBlowser *obj))browser delete:(void (^)(void))deletion{
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

@end
