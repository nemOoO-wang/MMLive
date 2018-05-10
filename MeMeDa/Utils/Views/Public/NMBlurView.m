//
//  NMBlurView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMBlurView.h"


IB_DESIGNABLE
@implementation NMBlurView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.clipsToBounds = YES;
    if (!self.cornerRadius) {
        self.cornerRadius = 10;
    }
    self.layer.cornerRadius = self.cornerRadius;
    
    // blur effect
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurEffectView.alpha = 0.9;
        if (self.subviews.count>0) {
            [self insertSubview:blurEffectView belowSubview:self.subviews[0]];
        }else{
            [self addSubview:blurEffectView];
        }
    } else {
        self.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    }
}

@end
