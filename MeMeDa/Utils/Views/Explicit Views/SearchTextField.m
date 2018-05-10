//
//  SearchTextField.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SearchTextField.h"


IB_DESIGNABLE
@implementation SearchTextField

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_seach"]];
    imgView.contentMode = UIViewContentModeRight;
    CGRect imgRect = CGRectMake(0, 0, 35, 24);
    imgView.frame = imgRect;
    self.leftView = imgView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
