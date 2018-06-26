//
//  VideoCallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/21/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "VideoCallVC.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
// ntes
#import "NTESLiveViewDefine.h"
#import "NTESMicConnector.h"
#import "NTESLiveAnchorHandler.h"
#import "NTESMediaCapture.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESLiveManager.h"
#import "NTESUserUtil.h"
#import "NTESCustomKeyDefine.h"
#import "NTESSessionMsgConverter.h"
#import "NTESDemoService.h"
#import "UIView+Toast.h"
#import "NTESLiveUtil.h"
// tools
#import "NSDictionary+NTESJson.h"
#import "NSString+NTES.h"
// custom
#import "AVAnchorContainerView.h"


@interface VideoCallVC ()<NTESLiveAnchorHandlerDelegate, NIMChatroomManagerDelegate, NIMChatManagerDelegate, NIMSystemNotificationManagerDelegate, NIMNetCallManagerDelegate>

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong) NIMNetCallMeeting *currentMeeting;

@property (nonatomic, strong) NTESMediaCapture  *capture;

@property (weak, nonatomic) IBOutlet UIView *captureView;

@property (nonatomic, strong) UIView *innerView;

@property (nonatomic, strong) NTESLiveAnchorHandler *handler;

@property (nonatomic, strong) UIImageView *focusView;

@end

@implementation VideoCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建房间
    [SVProgressHUD show];
    NSString *errorToast = @"进入失败，请重试";
    NSString *meetingName = [NSUUID UUID].UUIDString;
    [[NTESDemoService sharedService] requestLiveStream:meetingName completion:^(NSError *error, NIMChatroom *chatroom) {
        if (!error)
        {
            // on init
            self.chatroom = chatroom;
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.handler = [[NTESLiveAnchorHandler alloc] initWithChatroom:chatroom];
            self.handler.delegate = self;
            self.capture = [[NTESMediaCapture alloc]init];
            [self.capture switchContainerToView:self.captureView];
            
            NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
            request.roomId = chatroom.roomId;
            request.roomNotifyExt = [@{
                                       @"type"  : @([NTESLiveManager sharedInstance].type),
                                       @"meetingName": meetingName
                                       } jsonBody];
            
            [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError *error, NIMChatroom *room, NIMChatroomMember *me) {
                [SVProgressHUD dismiss];
                if (!error) {
                    //这里拿到的是应用服务器的人数，没有把自己加进去，手动添加。
                    chatroom.onlineUserCount++;
                    //将room的扩展也加进去
                    chatroom.ext =[NTESLiveUtil jsonString:chatroom.ext addJsonString:request.roomNotifyExt];
                    
                    [[NTESLiveManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
                    [[NTESLiveManager sharedInstance] cacheChatroom:chatroom];
                    
//                    NTESAnchorLiveViewController *vc = [[NTESAnchorLiveViewController alloc]initWithChatroom:chatroom];
//                    [wself.navigationController presentViewController:vc animated:YES completion:nil];
                    // view did load 执行
//                    [NTESLiveManager sharedInstance].orientation = self.orientation;
                    [[NIMAVChatSDK sharedSDK].netCallManager setVideoCaptureOrientation:[NTESLiveManager sharedInstance].orientation];
                    [self setUp];
                    NSLog(@"enter live room , live room type %ld, current user: %@",(long)[NTESLiveManager sharedInstance].type,[[NIMSDK sharedSDK].loginManager currentAccount]);
                    //视频直播
                    [NTESLiveManager sharedInstance].type = NTESLiveTypeVideo;
                    [self.capture switchContainerToView:self.captureView];
                    if (!self.capture.isLiveStream) {
                        [self.capture startLiveStreamHandler:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
                            if (error) {
                                [SVProgressHUD showErrorWithStatus:@"直播初始化失败"];
                            }else
                            {
                                //将服务器连麦请求队列清空
                                [[NIMSDK sharedSDK].chatroomManager dropChatroomQueue:self.chatroom.roomId completion:nil];
                                //发一个全局断开连麦的通知给观众，表示之前的连麦都无效了
                                [self sendDisconnectedNotify:nil];
                            }
                        }];
                    }
                }else{
                    NSLog(@"enter chat room error , code : %zd",error.code);
                    [SVProgressHUD showErrorWithStatus:errorToast];
                }
            }];
        }
        else
        {
            [SVProgressHUD dismiss];
            NSLog(@"request stream error , code : %zd",error.code);
            [SVProgressHUD showErrorWithStatus:errorToast];
        }
    }];
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
{
    if (self) {
        _chatroom = chatroom;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _handler = [[NTESLiveAnchorHandler alloc] initWithChatroom:chatroom];
        _handler.delegate = self;
        _capture = [[NTESMediaCapture alloc]init];
    }
    return self;
    
}

- (void)setUp
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.captureView];
    [self.view addSubview:self.focusView];
    
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESLiveManager sharedInstance] stop];
}

# pragma mark - <NTESLiveAnchorHandlerDelegate>
- (void)didUpdateConnectors{
    NSLog(@"更新了连接者");
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
        NSLog(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        [self.capture stopLiveStream];
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
        [SVProgressHUD showErrorWithStatus:toast];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    NSLog(@"chatroom connection state changed roomId : %@  state : %zd",roomId,state);
}


#pragma mark - NIMChatManagerDelegate
// 聊天室内置 IM
- (void)willSendMessage:(NIMMessage *)message{}
- (void)onRecvMessages:(NSArray *)messages{}


#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    NSString *content  = notification.content;
    NSDictionary *dict = [content jsonObject];
    NTESLiveCustomNotificationType type = [dict jsonInteger:@"command"];
    switch (type) {
        case NTESLiveCustomNotificationTypePushMic:
        case NTESLiveCustomNotificationTypePopMic:
        case NTESLiveCustomNotificationTypeRejectAgree:
            [self.handler dealWithBypassCustomNotification:notification];
            break;
        default:
            break;
    }
}


#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"on user joined uid %@",uid);
    NTESMicConnector *connector = [[NTESLiveManager sharedInstance] findConnector:uid];
    if (connector) {
        connector.state = NTESLiveMicStateConnected;
        [NTESLiveManager sharedInstance].connectorOnMic = connector;
        
        //将连麦者的GLView扔到右下角，并显示名字
//        [self.innerView switchToBypassStreamingUI:connector];
        
        //发送全局已连麦通知
        [self sendConnectedNotify:connector];
        
        //修改服务器队列
        NTESQueuePushData *data = [[NTESQueuePushData alloc] init];
        data.roomId = self.chatroom.roomId;
        data.ext = [@{@"style":@(connector.type),
                      @"state":@(NTESLiveMicStateConnected),
                      @"info":@{
                              @"nick" : connector.nick.length? connector.nick : connector.uid,
                              @"avatar":connector.avatar.length? connector.avatar : @"avatar_default"}} jsonBody];
        data.uid = uid;
        [[NTESDemoService sharedService] requestMicQueuePush:data completion:nil];
    }
}

- (void)sendConnectedNotify:(NTESMicConnector *)connector
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithConnectedMic:connector];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)sendDisconnectedNotify:(NTESMicConnector *)connector
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithDisconnectedMic:connector];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"on user left %@",uid);
    DDLogInfo(@"current on mic user is %@",[NTESLiveManager sharedInstance].connectorOnMic.uid);
    
    NTESMicConnector *connectorOnMic = [NTESLiveManager sharedInstance].connectorOnMic;
    if (!connectorOnMic) {
        DDLogError(@"error: on mic user is empty!");
        return;
    }
    //修改服务器队列
    NTESQueuePopData *data = [[NTESQueuePopData alloc] init];
    data.roomId = self.chatroom.roomId;
    data.uid    = connectorOnMic.uid;
    
    [[NTESDemoService sharedService] requestMicQueuePop:data completion:^(NSError *error, NSString *ext) {
        if (error) {
            DDLogError(@"request mic queue pop error %zd",error.code);
        }
    }];
    
    //修正内存队列
    [[NTESLiveManager sharedInstance] removeConnectors:uid];
    [NTESLiveManager sharedInstance].connectorOnMic = nil;
    
    //发送全局连麦者断开的通知
    [self sendDisconnectedNotify:connectorOnMic];
    
    //切回没有小窗口的画面
//    [self.innerView switchToPlayingUI];
}


- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    DDLogError(@"on meeting error: %zd",error);
    [self.view.window makeToast:[NSString stringWithFormat:@"互动直播失败 code: %zd",error.code] duration:2.0 position:CSToastPositionCenter];
    [NTESLiveManager sharedInstance].connectorOnMic = nil;
    [self.capture stopLiveStream];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
//    [self.innerView updateRemoteView:yuvData width:width height:height];
    // 连接方直播
}

-(void)onCameraTypeSwitchCompleted:(NIMNetCallCamera)cameraType
{
    if (cameraType == NIMNetCallCameraBack) {
        // 后摄像头
    }
}

-(void)onCameraOrientationSwitchCompleted:(NIMVideoOrientation)orientation
{
    [self.capture onCameraOrientationSwitchCompleted:orientation];
}

- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user
{
    if ([user isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        // 网络情况
    }
}


@end
