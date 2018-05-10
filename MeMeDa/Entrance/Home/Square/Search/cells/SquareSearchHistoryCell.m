//
//  SquareSearchHistoryCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareSearchHistoryCell.h"


@interface SquareSearchHistoryCell()

@end


@implementation SquareSearchHistoryCell

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.layer.borderColor = [UIColor colorWithHexString:@"8B8B8B"].CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 3;
}

@end
