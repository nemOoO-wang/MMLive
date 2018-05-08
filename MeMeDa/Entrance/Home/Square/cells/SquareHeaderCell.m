//
//  SquareHeaderCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/8/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareHeaderCell.h"


@interface SquareHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end


@implementation SquareHeaderCell

-(void)setType:(SquareHeaderType)type{
    _type = type;
    UIImage *img;
    switch (type) {
        case SquareHeaderTypeReMen:
            img = [UIImage imageNamed:@"icon_liebiao_remen"];
            break;
        case SquareHeaderTypeNanRen:
            img = [UIImage imageNamed:@"icon_liebiao_nanyonghu"];
            break;
        case SquareHeaderTypeShuRen:
            img = [UIImage imageNamed:@"icon_liebiao_suren"];
            break;
        case SquareHeaderTypeTuJian:
            img = [UIImage imageNamed:@"icon_liebiao_tujian"];
            break;
        case SquareHeaderTypeGuanZhu:
            img = [UIImage imageNamed:@"icon_liebiao_guanzhu"];
            break;
        case SquareHeaderTypeHuoDong:
            img = [UIImage imageNamed:@"icon_liebiao_huodong"];
            break;
        default:
            img = [UIImage imageNamed:@"icon_liebiao_remen"];
            break;
    }
    [self.imgView setImage:img];
}

@end
