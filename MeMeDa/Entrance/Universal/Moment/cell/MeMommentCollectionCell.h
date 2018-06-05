//
//  MeMommentCollectionCell.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeMommentCollectionCell : UICollectionViewCell

@property (nonatomic,strong) NSArray<NSString *> *imgArr;
@property (nonatomic,strong) NSString *context;
@property (nonatomic,strong) NSDictionary *dataDic;


@end
