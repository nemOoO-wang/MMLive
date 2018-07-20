//
//  SquareListGirlsCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareListGirlsCell.h"


@interface SquareListGirlsCell()

@end


@implementation SquareListGirlsCell

-(void)setUDic:(NSDictionary *)uDic{
    _uDic = uDic;
    self.nameLabel.text = uDic[@"nickname"];
    self.subTitleLabel.text = uDic[@"mark"];
    [self.usrImgView sd_setImageWithURL:[NSURL URLWithString:uDic[@"headImg"]]];
    self.occupationLabel.text = uDic[@"profession"];
    NSString *online = ([uDic[@"onlineState"] integerValue]==1)? @"在线": @"离线";
    self.onlineLabel.text = online;
    self.feeLabel.text = [NSString stringWithFormat:@"%ld币/分钟",[uDic[@"price"] integerValue]];
}

@end
