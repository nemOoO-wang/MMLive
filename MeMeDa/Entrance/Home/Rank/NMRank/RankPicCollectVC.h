//
//  RankPicCollectVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/10/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RankViewType) {
    RankViewTypeTuHao,
    RankViewTypeNvSheng,
};

@interface RankPicCollectVC : UIViewController

@property (nonatomic,assign) RankViewType VCType;

@end
