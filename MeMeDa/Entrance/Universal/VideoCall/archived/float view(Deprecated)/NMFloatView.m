//
//  NMFloatView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/27/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMFloatView.h"
#import "UIWindow+NMCurrent.h"

@interface NMFloatView()

@property (nonatomic,assign) CGPoint panOriginPoint;

@end


@implementation NMFloatView

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

-(void)didMoveToSuperview{
    // pan
    UIPanGestureRecognizer *panGstr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragWith:)];
    [self addGestureRecognizer:panGstr];
    // click
    UITapGestureRecognizer *tapGstr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWith:)];
    [self addGestureRecognizer:tapGstr];
}

-(void)tapWith:(UITapGestureRecognizer *)gesture{
    NSLog(@"@#!@#@!#!@");
}

-(void)dragWith:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self fixFrame];
    }else{
    UIView *suppView = [[[[UIApplication sharedApplication] keyWindow] getCurrentViewController] view];
    self.center = [gesture locationInView:suppView];
    }
}

-(void)fixFrame{
    if(self.frame.origin.x != 0 && self.frame.origin.x+self.frame.size.width != SCREEN_WIDTH){
        CGFloat fixedY = self.center.y;
        if (self.center.y) {
            if (self.frame.origin.y<0) {
                fixedY = 20+self.frame.size.height;
            }
            if (self.frame.origin.y+self.frame.size.height>SCREEN_HEIGHT) {
                fixedY = SCREEN_HEIGHT-self.frame.size.height;
            }
        }
        if (self.center.x > SCREEN_WIDTH/2) {
            [UIView animateWithDuration:0.3 delay:0.05 usingSpringWithDamping:2 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.center = CGPointMake(SCREEN_WIDTH-self.frame.size.width/2, fixedY);
//                self.frame = CGRectMake(SCREEN_WIDTH-self.frame.size.width, fixedY, self.frame.size.width, self.frame.size.height);
            } completion:nil];
        }else{
            [UIView animateWithDuration:0.3 delay:0.05 usingSpringWithDamping:2 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.center = CGPointMake(self.frame.size.width/2, fixedY);
            } completion:nil];
        }
    }
}

@end
