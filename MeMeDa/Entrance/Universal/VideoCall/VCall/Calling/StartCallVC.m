//
//  StartCallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "StartCallVC.h"
#import "VCallVC.h"
#import "ACallVC.h"
#import "NMFloatWindow.h"


@interface StartCallVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *clickEndGstrue;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressBg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endCallLabel;
@property (nonatomic,assign) BOOL RecallState;
@property (nonatomic,strong) NSString *trId;
@end

@implementation StartCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissNoti:) name:@"End Audio Call" object:nil];
    [self requestRoom];
    // init info
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.usrDic[@"headImg"]]];
    self.nameLabel.text = self.usrDic[@"nickname"];
}

-(void)viewDidAppear:(BOOL)animated{
    // count down
    [self CountDown];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dismissNoti:(NSNotification *)noti{
    [self dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)requestRoom{
    self.clickEndGstrue.enabled = NO;
    // 请求开房
    if (self.audioCall) {
        // 语音
        NSDictionary *paramDic = @{@"userId":self.usrDic[@"id"], @"type":@3};;
        [[BeeNet sharedInstance] requestWithType:Request_POST url:@"/chat/user/makeCall" param:paramDic success:^(id data) {
            self.trId = [data[@"data"][@"id"] stringValue];
            self.clickEndGstrue.enabled = YES;
            // 发送自定义 RC 消息
            NMRCCallMessage *message = [[NMRCCallMessage alloc] init];
            message.roomName = @"";
            NSDictionary *dic = MDUserDic;
            message.nickname = dic[@"nickname"];
            message.headImg = dic[@"headImg"];
            message.uId = dic[@"id"];
            message.trId = self.trId;
            message.code = @"5";
            NSString *content = [NSString stringWithFormat:@"%@邀请您进行通话",dic[@"nickname"]];
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PUSHSERVICE targetId:[self.usrDic[@"id"] stringValue] content:message pushContent:content pushData:nil success:^(long messageId) {
            } error:^(RCErrorCode nErrorCode, long messageId) {
            }];
        } fail:^(NSString *message) {
            [SVProgressHUD showErrorWithStatus:message];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }else{
        // 视频
        NSDictionary *paramDic = @{@"userId":self.usrDic[@"id"], @"type":@2};;
        [[BeeNet sharedInstance] requestWithType:Request_POST url:@"/chat/user/makeCall" param:paramDic success:^(id data) {
            self.trId = [data[@"data"][@"id"] stringValue];
            self.clickEndGstrue.enabled = YES;
            // 发送自定义 RC 消息
            NMRCCallMessage *message = [[NMRCCallMessage alloc] init];
            message.roomName = @"";
            NSDictionary *dic = MDUserDic; 
            message.nickname = dic[@"nickname"];
            message.headImg = dic[@"headImg"];
            message.uId = [dic[@"id"] stringValue];
            message.trId = self.trId;
            message.code = @"1";
            NSString *content = [NSString stringWithFormat:@"%@邀请您进行通话",dic[@"nickname"]];
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PUSHSERVICE targetId:[self.usrDic[@"id"] stringValue] content:message pushContent:content pushData:nil success:^(long messageId) {
            } error:^(RCErrorCode nErrorCode, long messageId) {
            }];
        } fail:^(NSString *message) {
            [SVProgressHUD showErrorWithStatus:message];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (IBAction)clickEndCal:(id)sender {
    if (self.RecallState) {
        [self requestRoom];
        self.RecallState = NO;
        self.endCallLabel.text = @"挂断";
        [self CountDown];
    }else{
        NSDictionary *paramDic = @{@"trId":self.trId?self.trId:@"", @"userId":self.usrDic[@"id"]};
        [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/hangUp" andParam:paramDic andSuccess:nil];
        NMRCCallMessage *msg = [[NMRCCallMessage alloc] init];
        NSDictionary *dic = MDUserDic;
        msg.nickname = dic[@"nickname"];
        msg.headImg = dic[@"headImg"]? dic[@"headImg"]: @"";
        msg.uId = dic[@"id"];
        msg.trId = self.trId;
        msg.code = @"3";
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PUSHSERVICE targetId:[self.usrDic[@"id"] stringValue] content:msg pushContent:@"用户挂断电话" pushData:nil success:^(long messageId) {
        } error:^(RCErrorCode nErrorCode, long messageId) {
        }];
        [self endCall];
    }
}

-(void)endCall{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)CountDown{
    CGRect origin = self.progressView.frame;
    CGSize full = self.progressBg.bounds.size;
    origin.size.width = full.width;
    [UIView animateWithDuration:30 animations:^{
        self.progressView.frame = origin;
    } completion:^(BOOL finished) {
        if (finished) {
            self.endCallLabel.text = @"重拨";
            self.RecallState = YES;
            CGRect origin = self.progressView.frame;
            origin.size.width = 0;
            self.progressView.frame = origin;
        }
    }];
}

-(void)handleResponse{
    //初始化会议
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    //指定会议名
    meeting.name = self.roomName;
    meeting.actor = YES;

    VCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"calling"];
    vc.meeting = meeting;
    vc.userType = CallUserDefault;
    vc.calllMsg = self.msg;
    [NMFloatWindow keyFLoatWindow].frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2);
    [[NMFloatWindow keyFLoatWindow] setFullScreenWithoutAni:YES];
    [NMFloatWindow keyFLoatWindow].rootViewController = vc;
    [[NMFloatWindow keyFLoatWindow] show];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)handleAudioResponse{
    //初始化会议
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    //指定会议名
    meeting.name = self.roomName;
    meeting.actor = YES;
    meeting.type = NIMNetCallTypeAudio;
    
    ACallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"audio call"];
    vc.meeting = meeting;
    vc.userType = CallUserDefault;
    vc.calllMsg = self.msg;
//    [NMFloatWindow keyFLoatWindow].frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2);
//    [[NMFloatWindow keyFLoatWindow] setFullScreenWithoutAni:YES];
//    [NMFloatWindow keyFLoatWindow].rootViewController = vc;
//    [[NMFloatWindow keyFLoatWindow] show];
    [self presentViewController:vc animated:YES completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
