//
//  MeMommentCollectionCell.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeMommentCollectionCell : UICollectionViewCell

// head
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextFieldHeightConstraint;
// like btn
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoLabel;

@property (nonatomic,strong) NSArray<NSString *> *imgArr;
@property (nonatomic,strong) NSString *context;
@property (nonatomic,strong) NSDictionary *dataDic;


@end
