//
//  EavesdropVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/18/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EavesdropVC : UIViewController

@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign) NSInteger currentShowTbl;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 10人与您一起偷听
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
// constraint
/// 15/ -190
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tb1ToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tb2ToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tb3ToBottom;
@property (weak, nonatomic) IBOutlet UITableView *tb1;
@property (weak, nonatomic) IBOutlet UITableView *tb2;
@property (weak, nonatomic) IBOutlet UITableView *tb3;

@end
