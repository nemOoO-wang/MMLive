//
//  ACallVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/27/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import "NMRCCallMessage.h"
#import "VCallVC.h"


@interface ACallVC : UIViewController

@property (nonatomic,assign) CallUser userType;
@property (nonatomic,strong) NIMNetCallMeeting *meeting;
@property (nonatomic,strong) NMRCCallMessage *calllMsg;

@end
