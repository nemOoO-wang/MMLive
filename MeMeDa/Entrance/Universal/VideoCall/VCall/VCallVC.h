//
//  VCallVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/27/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVAnchorContainerView.h"

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

@end
