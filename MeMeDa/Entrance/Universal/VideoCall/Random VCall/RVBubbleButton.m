//
//  RVBubbleButton.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "RVBubbleButton.h"

#define ButtonSize 70
#define BiasWidth 400

@implementation RVBubbleButton

# pragma mark - click



# pragma mark - animation
-(void)fire{
    // layoutview
    // img mode
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.frame = CGRectMake(20, 20, ButtonSize, ButtonSize);
    // corner
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
    // fix position
    CGSize containerSize = self.superview.bounds.size;
    CGFloat startY = containerSize.height + ButtonSize/2;
    CGFloat deltaWidth = ButtonSize + 100;
    CGFloat starX = arc4random_uniform(containerSize.width-deltaWidth)+deltaWidth/2;
    CGFloat bias = arc4random_uniform(BiasWidth);
    bias -= BiasWidth/2;
    self.center = CGPointMake(starX, startY);
    // fire
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGFloat edgeX = starX + bias;
        if (edgeX < ButtonSize/2) {
            edgeX = ButtonSize/2;
        }
        if (edgeX > containerSize.width-ButtonSize/2) {
            edgeX = containerSize.width-ButtonSize/2;
        }
        self.center = CGPointMake(edgeX, -ButtonSize);
        self.alpha = 0.4;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
