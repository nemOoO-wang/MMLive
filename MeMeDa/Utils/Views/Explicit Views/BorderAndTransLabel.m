

//
//  BorderAndTransLabel.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "BorderAndTransLabel.h"


IB_DESIGNABLE
@implementation BorderAndTransLabel

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
    [self setBackgroundColor:self.bgColor];
    [self.layer setBorderColor:self.borderColor.CGColor];
    [self.layer setBorderWidth:2];
}

@end
