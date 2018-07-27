//
//  ACallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/27/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ACallVC.h"
#import "UserEndCallVC.h"
#import "AnchorEndCallVC.h"


@interface ACallVC ()<NIMNetCallManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong) NSString *otherManTrId;

@end

@implementation ACallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.userType == CallUserAnchor) {
        NMRCCallMessage *msg = [[NMRCCallMessage alloc] init];
        msg.roomName = self.meeting.name;
        NSDictionary *dic = MDUserDic;
        msg.nickname = dic[@"nickname"];
        msg.headImg = dic[@"headImg"];
        msg.uId = dic[@"id"];
        msg.trId = self.calllMsg.trId;
        msg.code = @"6";
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PUSHSERVICE targetId:self.calllMsg.uId content:msg pushContent:@"主播回应接听" pushData:nil success:^(long messageId) {
        } error:^(RCErrorCode nErrorCode, long messageId) {
        }];
    }
    
    NIMNetCallOption *opt = [[NIMNetCallOption alloc] init];
    self.meeting.option = opt;
    
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    //加入会议
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:self.meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        //加入会议失败
        if (error) {
        }
        //加入会议成功
        else
        {
            //开启扬声器
//            [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:YES];
            [SVProgressHUD showSuccessWithStatus:@"进入房间成功"];
        }
    }];
}

- (IBAction)clickEnd:(id)sender {
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.meeting];
    // 后台
    NSDictionary *paramDic = @{@"trId":self.calllMsg.trId};
    [[BeeNet sharedInstance] requestWithType:Request_POST url:@"/chat/user/doneHangUp" param:paramDic success:^(id data) {
    } fail:^(NSString *message) {
    }];
    
    // 跳转
    if (self.userType == CallUserDefault) {
        UserEndCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"user end"];
//        [NMFloatWindow keyFLoatWindow].rootViewController = vc;
        vc.audioCall = YES;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        AnchorEndCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"anchor end"];
//        [NMFloatWindow keyFLoatWindow].rootViewController = vc;
        vc.audioCall = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - NIMNetCallManagerDelegate
//收到用户加入通知
- (void)onUserJoined:(NSString *)uid meeting:(NIMNetCallMeeting *)meeting
{
    //更新会议在线人数
    if (!self.otherManTrId) {
        self.otherManTrId = uid;
    }
//    else{
//        self.peopleCount++;
//        self.peopleCountLabel.text = [NSString stringWithFormat:@"%ld 人正在偷听",self.peopleCount];
//    }
    
}

// 用户离开
-(void)onUserLeft:(NSString *)uid meeting:(NIMNetCallMeeting *)meeting{
    if ([uid isEqualToString:self.otherManTrId]) {
        [SVProgressHUD showInfoWithStatus:@"对方挂断电话"];
        [self clickEnd:nil];
    }
}

//会议发生错误
- (void)onMeetingError:(NSError *)error meeting:(NIMNetCallMeeting *)meeting
{
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
