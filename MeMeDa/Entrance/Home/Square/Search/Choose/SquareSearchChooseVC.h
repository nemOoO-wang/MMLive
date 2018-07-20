//
//  SquareSearchChooseVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareSearchVC.h"


@interface SquareSearchChooseVC : UIViewController

@property (nonatomic,strong) UIVisualEffectView *coverView;
@property (nonatomic,strong) NSString *siftKey;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *subDataArr;
@property (nonatomic,weak) SquareSearchVC *vc;


@end
