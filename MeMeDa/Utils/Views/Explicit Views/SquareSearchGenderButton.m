
//
//  SquareSearchGenderButton.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareSearchGenderButton.h"


IB_DESIGNABLE
@implementation SquareSearchGenderButton

-(void)setOn:(BOOL)on{
    _on = on;
    if(on){
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.backgroundColor = [UIColor colorWithHexString:@"7F7F7F"];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 5;
}

@end
