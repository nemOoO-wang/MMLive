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
@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation SquareHeaderCell

-(void)setType:(SquareHeaderType)type{
    _type = type;
    UIImage *img;
    switch (type) {
        case SquareHeaderTypeReMen:
            img = [UIImage imageNamed:@"icon_liebiao_remen"];
            self.label.text = @"热门列表";
            break;
        case SquareHeaderTypeShuRen:
            img = [UIImage imageNamed:@"icon_liebiao_suren"];
            self.label.text = @"素人列表";
            break;
        case SquareHeaderTypeTuJian:
            img = [UIImage imageNamed:@"icon_liebiao_tuijian"];
            self.label.text = @"推荐列表";
            break;
        case SquareHeaderTypeGuanZhu:
            img = [UIImage imageNamed:@"icon_liebiao_guanzhu"];
            self.label.text = @"关注列表";
            break;
        case SquareHeaderTypeHuoDong:
            img = [UIImage imageNamed:@"icon_liebiao_huodong"];
            self.label.text = @"活动主题";
            break;
        default:
            img = [UIImage imageNamed:@"icon_liebiao_remen"];
            self.label.text = @"热门列表";
            break;
    }
    [self.imgView setImage:img];
}

@end
