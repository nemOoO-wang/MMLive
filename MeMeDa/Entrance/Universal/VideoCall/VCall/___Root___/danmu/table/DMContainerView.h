//
//  DMContainerView.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/18/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMContainerView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;


@end
