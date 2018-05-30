//
//  CityPickerVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityPickerVC : UIViewController

@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;

@property (nonatomic,strong) void(^pickLocation) (NSString *location);
@property (nonatomic,strong) NSArray *indexsArr;


@end
