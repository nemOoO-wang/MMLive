//
//  BeCalledVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "BeCalledVC.h"
#import "VCallVC.h"
#import "ACallVC.h"
#import "NMFloatWindow.h"


@interface BeCalledVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BeCalledVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissNoti:) name:@"End Audio Call" object:nil];
    self.nameLabel.text = self.msg.nickname;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.msg.headImg]];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dismissNoti:(NSNotification *)noti{
    [self dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAccept:(id)sender {
    [SVProgressHUD showWithStatus:@"连接中"];
    // 主播接听
    // 申请会议
    //初始化会议
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    //指定会议名
    meeting.name = [NSUUID UUID].UUIDString;
    meeting.actor = YES;
    //预订会议
    if (self.audioCall) {
        // 音频聊天
//        meeting.type = NIMNetCallMediaTypeAudio;
        [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
            //预订会议失败
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"开房失败"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //预订会议成功
            else {
                // new vc
                ACallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"audio call"];
                vc.userType = CallUserAnchor;
                vc.meeting = meeting;
                vc.calllMsg = self.msg;
//                [NMFloatWindow keyFLoatWindow].frame = [UIScreen mainScreen].bounds;
//                [NMFloatWindow keyFLoatWindow].fullScreen = YES;
//                [NMFloatWindow keyFLoatWindow].rootViewController = vc;
                [self presentViewController:vc animated:YES completion:nil];
//                [self dismissViewControllerAnimated:NO completion:nil];
                [SVProgressHUD dismiss];
            }
        }];
    }else{
        // 视频聊天
        [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
            //预订会议失败
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"开房失败"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //预订会议成功
            else {
                // new vc
                VCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"calling"];
                vc.userType = CallUserAnchor;
                vc.meeting = meeting;
                vc.callerId = self.msg.uId;
                vc.calllMsg = self.msg;
                [NMFloatWindow keyFLoatWindow].frame = [UIScreen mainScreen].bounds;
                [NMFloatWindow keyFLoatWindow].fullScreen = YES;
                [NMFloatWindow keyFLoatWindow].rootViewController = vc;
                [self dismissViewControllerAnimated:NO completion:nil];
                [SVProgressHUD dismiss];
            }
        }];
    }
}
- (IBAction)clickRefuse:(id)sender {
    NMRCCallMessage *msg = [[NMRCCallMessage alloc] init];
    NSDictionary *dic = MDUserDic;
    msg.nickname = dic[@"nickname"];
    msg.headImg = dic[@"headImg"];
    msg.uId = dic[@"id"];
    msg.trId = self.msg.trId;
    msg.code = @"4";
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PUSHSERVICE targetId:self.callerId content:msg pushContent:@"用户挂断电话" pushData:nil success:^(long messageId) {
    } error:^(RCErrorCode nErrorCode, long messageId) {
    }];
    NSDictionary *paramDic = @{@"trId":self.msg.trId?self.msg.trId:@"", @"userId":dic[@"id"]};
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/hangUp" andParam:paramDic andSuccess:nil];    
    [self endCall];
}

-(void)endCall{
    if (self.audioCall) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [[NMFloatWindow keyFLoatWindow] dismiss];
    }
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
