//
//  HittestView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "HittestView.h"

@implementation HittestView

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
