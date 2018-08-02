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
#import "BarrageMessage.h"
#import "DMContainerView.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import "AnchorEndCallVC.h"
#import "UserEndCallVC.h"
#import "NMRCCallMessage.h"


typedef NS_ENUM(NSInteger, CallUser) {
    CallUserAnchor,
    CallUserDefault,
};

@interface VCallVC : UIViewController

@property (nonatomic,assign) CallUser userType;
// 主播回拨用户使用的属性
@property (nonatomic, assign) BOOL directRingBack;
@property (nonatomic,strong) NSString *subId;
@property (nonatomic,strong) NSString *trId;
//@property (nonatomic,assign) NSString *callingAnchorId;
@property (nonatomic,strong) NSString *callerId;
@property (nonatomic,strong) NIMNetCallMeeting *meeting;
@property (weak, nonatomic) IBOutlet AVAnchorContainerView *menuContainerView;
@property (weak, nonatomic) IBOutlet UIView *smallVideoView;
@property (weak, nonatomic) IBOutlet UIView *localVideoView;
@property (nonatomic,strong) UIView *localPreView;
@property (nonatomic,strong) NMRCCallMessage *calllMsg;

// info data
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadImgView;
@property (nonatomic,assign) BOOL meInBig;
@property (nonatomic,assign) NSInteger peopleCount;
// danmu
@property (weak, nonatomic) IBOutlet DMContainerView *danmuView;


- (IBAction)clickEndCall:(id)sender;

@property (nonatomic,strong) NSArray *danmuArr;

@end
