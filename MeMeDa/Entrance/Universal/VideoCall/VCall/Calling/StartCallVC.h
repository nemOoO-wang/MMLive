//
//  StartCallVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartCallVC : UIViewController

@property (nonatomic,strong) NSDictionary *usrDic;
@property (nonatomic,strong) NSDictionary *callDataDic;

-(void)handleResponse;

@end
