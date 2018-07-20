//
//  SquareListGirlsCell.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderAndTransLabel.h"


@interface SquareListGirlsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BorderAndTransLabel *onlineLabel;
@property (weak, nonatomic) IBOutlet BorderAndTransLabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *usrImgView;

@property (nonatomic,strong) NSDictionary *uDic;

@end
