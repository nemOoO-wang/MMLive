//
//  NMRegTextField.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMRegTextField.h"


IB_DESIGNABLE
@implementation NMRegTextField

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.placeString) {
        self.placeString = @"请输入";
    }
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:21];
    self.textColor = [UIColor whiteColor];
    self.tintColor = [UIColor colorWithWhite:255 alpha:0.4];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeString attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:255 alpha:0.4]}];
    self.borderStyle = UITextBorderStyleNone;
}

@end
