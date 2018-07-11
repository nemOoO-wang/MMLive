//
//  NMFloatWindow.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/10/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMFloatWindow.h"
#import "UIWindow+NMCurrent.h"
#import "VCallVC.h"


@implementation NMFloatWindow

static NMFloatWindow *_instance = nil;

+(instancetype)keyFLoatWindow{
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

-(instancetype)init{
    if (self = [super init]) {
        // default small frame
        CGFloat ratio = SCREEN_HEIGHT/SCREEN_WIDTH;
        self.defaultSmallFrame = CGRectMake(0, 100, 100, 100*ratio);
        self.layer.masksToBounds = YES;
        // pan
        self.panGstr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragWith:)];
        [self addGestureRecognizer:self.panGstr];
        // click
        self.tapGstr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWith:)];
        [self addGestureRecognizer:self.tapGstr];
        // show as alert window
        UIWindow *originWin = [[UIApplication sharedApplication] keyWindow];
        self.windowLevel = UIWindowLevelStatusBar - 1;
        [self makeKeyAndVisible];
        [originWin makeKeyAndVisible];
    }
    return self;
}

-(void)setFullScreen:(BOOL)fullScreen{
    if (_fullScreen == fullScreen) {
        return;
    }
    _fullScreen = fullScreen;
    CGRect frame;
    if (fullScreen) {
        self.panGstr.enabled = NO;
        self.tapGstr.enabled = NO;
        self.defaultSmallFrame = self.frame;
        frame = [UIScreen mainScreen].bounds;
    }else{
        self.panGstr.enabled = YES;
        self.tapGstr.enabled = YES;
        frame = self.defaultSmallFrame;
    }
    // enable menu
    if (fullScreen) {
        if ([self.rootViewController isKindOfClass:[VCallVC class]]) {
            VCallVC *vc = (VCallVC *)self.rootViewController;
            vc.menuContainerView.alpha = 1;
            vc.smallVideoView.alpha = 1;
        }
    }
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.rootViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }];
}

-(void)setFullScreenWithoutAni:(BOOL)fullScreen{
    _fullScreen = fullScreen;
    if (fullScreen) {
        self.panGstr.enabled = NO;
        self.tapGstr.enabled = NO;
    }else{
        self.panGstr.enabled = YES;
        self.tapGstr.enabled = YES;
    }
}

-(void)setDefaultSmallFrame:(CGRect)defaultSmallFrame{
    _defaultSmallFrame = defaultSmallFrame;
}

-(void)dismiss{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}
-(void)show{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}

# pragma mark - Gestrures
-(void)tapWith:(UITapGestureRecognizer *)gesture{
    NSLog(@"@#!@#@!#!@");
    self.fullScreen = !self.fullScreen;
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
        // fix y
        if (self.frame.origin.y<22) {
            fixedY = 20+self.frame.size.height;
        }
        if (self.frame.origin.y+self.frame.size.height>SCREEN_HEIGHT) {
            fixedY = SCREEN_HEIGHT-self.frame.size.height;
        }
        // fix x
        if (self.center.x > SCREEN_WIDTH/2) {
            [UIView animateWithDuration:0.3 delay:0.05 usingSpringWithDamping:2 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.center = CGPointMake(SCREEN_WIDTH-self.frame.size.width/2, fixedY);
            } completion:nil];
        }else{
            [UIView animateWithDuration:0.3 delay:0.05 usingSpringWithDamping:2 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.center = CGPointMake(self.frame.size.width/2, fixedY);
            } completion:nil];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
