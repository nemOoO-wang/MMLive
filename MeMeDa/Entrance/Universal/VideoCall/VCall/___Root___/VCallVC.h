//
//  VCallVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/27/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVAnchorContainerView.h"
#import <RongIMLib/RongIMLib.h>
#import "DMContainerView.h"

typedef NS_ENUM(NSInteger, CallUser) {
    CallUserAnchor,
    CallUserDefault,
};

@interface VCallVC : UIViewController

@property (nonatomic,assign) CallUser userType;
@property (nonatomic,assign) NSString *callingAnchorId;
@property (nonatomic,strong) NSString *trId;
@property (nonatomic,strong) NIMNetCallMeeting *meeting;
@property (weak, nonatomic) IBOutlet AVAnchorContainerView *menuContainerView;
@property (weak, nonatomic) IBOutlet UIView *smallVideoView;
@property (weak, nonatomic) IBOutlet UIView *localVideoView;
@property (nonatomic,strong) UIView *localPreView;
// info data
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (nonatomic,assign) BOOL meInBig;
// danmu
@property (weak, nonatomic) IBOutlet DMContainerView *danmuView;

@property (nonatomic,strong) NSArray *danmuArr;

@end
