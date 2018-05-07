//
//  DatePickerVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerVC : UIViewController

@property (nonatomic,strong) void(^pickDate) (NSDate *date);
@property (nonatomic,strong) NSDate *oldDate;

@end
