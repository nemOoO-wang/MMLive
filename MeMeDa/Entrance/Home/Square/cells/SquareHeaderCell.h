//
//  SquareHeaderCell.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/8/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    SquareHeaderTypeShuRen,
    SquareHeaderTypeNanRen,
    SquareHeaderTypeReMen,
    SquareHeaderTypeHuoDong,
    SquareHeaderTypeGuanZhu,
    SquareHeaderTypeTuJian
} SquareHeaderType;

@interface SquareHeaderCell : UICollectionViewCell

@property (nonatomic,assign) SquareHeaderType type;

@end
