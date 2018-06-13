//
//  NMLongPressButton.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/11/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMLongPressButton.h"

@implementation NMLongPressButton

-(void)setNm_Delegate:(id<NMLongPressDelegate>)nm_Delegate{
    _nm_Delegate = nm_Delegate;
    UILongPressGestureRecognizer *rcg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:rcg];
}

-(void)longPress:(UILongPressGestureRecognizer *)rcg{
    if (rcg.state == UIGestureRecognizerStateEnded) {
        [self.nm_Delegate longPress:self];
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
