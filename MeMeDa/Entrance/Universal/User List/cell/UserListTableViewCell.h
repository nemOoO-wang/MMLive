//
//  UserListTableViewCell.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/11/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

// dataDic包含在这里面的时候，而且这个dic包含特殊字段的时候
@property (nonatomic, strong) NSDictionary *magaDic;

@end
