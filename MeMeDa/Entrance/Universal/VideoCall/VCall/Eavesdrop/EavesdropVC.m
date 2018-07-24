//
//  EavesdropVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/18/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "EavesdropVC.h"
#import "EavesdropVC+show.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>


@interface EavesdropVC ()

@end

@implementation EavesdropVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDanmu];
    [self enterNewRoom];
}

-(void)enterNewRoom{
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/eavesdrop" andParam:nil andSuccess:^(id data) {
        if (!data[@"data"]) {
            [SVProgressHUD showInfoWithStatus:@"暂时没有合适的房间偷听"];
        }else{
//            //初始化会议
//            NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
//            //指定会议名
//            meeting.name = self.roomName;
//            meeting.actor = NO;
            //加入会议
//            [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
//                //加入会议失败
//                if (error) {
//                }
//                //加入会议成功
//                else
//                {
//                    [[NIMAVChatSDK sharedSDK].netCallManager switchVideoQuality:NIMNetCallVideoQuality720pLevel];
//                    //开启扬声器
//                    [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:YES];
//                    [SVProgressHUD showSuccessWithStatus:@"进入房间成功"];
//                }
//            }];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickEnd:(id)sender {
    // 退出房间
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickChange:(id)sender {
    // 退出
    // 进入
}

-(void)quitRoom{
//    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.meeting];
}

@end
