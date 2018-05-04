//
//  NMLoginButton.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMLoginButton.h"
#import "UIColor+BeeColor.h"

IB_DESIGNABLE
@implementation NMLoginButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    CAGradientLayer *graLayer = [[CAGradientLayer alloc] init];
    graLayer.frame = self.bounds;
    if (!self.color1 || !self.color2) {
        self.color1 = [UIColor colorWithHexString:@"#FF2EB4"];
        self.color2 = [UIColor colorWithHexString:@"#FF6CC4"];
    }
    graLayer.colors = @[(__bridge id)self.color1.CGColor, (__bridge id)self.color2.CGColor];
    graLayer.startPoint = CGPointMake(0, 0.7);
    graLayer.endPoint = CGPointMake(1, 0.3);
    [self.layer insertSublayer:graLayer atIndex:0];
    
    self.clipsToBounds = YES;
    if (!self.cornerradius) {
        self.cornerradius = 24;
    }
    self.layer.cornerRadius = self.cornerradius;
    
}

@end
