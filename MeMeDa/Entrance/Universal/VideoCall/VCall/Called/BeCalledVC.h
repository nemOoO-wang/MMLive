//
//  BeCalledVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRCCallMessage.h"

@interface BeCalledVC : UIViewController

@property (nonatomic,strong) NSDictionary *callDataDic;
@property (nonatomic,strong) NSString *callerId;

@property (nonatomic,strong) NMRCCallMessage *msg;



@end
