//
//  RankPicCollectionCell.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/10/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankPicCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankNumLabel;

@end
