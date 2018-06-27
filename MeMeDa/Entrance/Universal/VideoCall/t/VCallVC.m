//
//  VCallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/27/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "VCallVC.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
// view
#import "NTESGLView.h"
#import "AVAnchorContainerView.h"


@interface VCallVC ()<NIMNetCallManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *localVideoView;
@property (nonatomic,strong) UIView *localPreView;
@property (nonatomic,strong) NIMNetCallVideoCaptureParam *videoParam;
@property (weak, nonatomic) IBOutlet UIView *smallVideoView;
@property (weak, nonatomic) IBOutlet AVAnchorContainerView *menuContainerView;
@property (weak, nonatomic) IBOutlet NTESGLView *glView;
@property (nonatomic,strong) NIMNetCallMeeting *meeting;
@property (nonatomic,assign) BOOL meInBig;

@end

@implementation VCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //tmp
    self.userType = CallUserAnchor;
    
    // 本地摄像头
    self.meInBig = YES;
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    // 音频清晰度
    [[NIMAVChatSDK sharedSDK].netCallManager selectVideoAdaptiveStrategy:NIMAVChatVideoAdaptiveStrategyQuality];
    //改变视频采集方向
    [[NIMAVChatSDK sharedSDK].netCallManager setVideoCaptureOrientation:NIMVideoOrientationPortrait];
    //切换为前摄像头
    [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraFront];
    //切换为自动对焦模式
    [[NIMAVChatSDK sharedSDK].netCallManager setFocusMode:NIMNetCallFocusModeAuto];
//    //选择自然模式进行美颜
//    [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:NIMNetCallFilterTypeZiran];
//    //进行磨皮 磨破强度选择0.5
//    [[NIMAVChatSDK sharedSDK].netCallManager setSmoothFilterIntensity:0.5];
//    //选择设置对比度 对比度强度选择2
//    [[NIMAVChatSDK sharedSDK].netCallManager setContrastFilterIntensity:2];
    // 初始化摄像
    self.localPreView = [[NIMAVChatSDK sharedSDK].netCallManager localPreview];
    //初始化采集参数
    self.videoParam = [[NIMNetCallVideoCaptureParam alloc]init];
    //开始采集
    [[NIMAVChatSDK sharedSDK].netCallManager startVideoCapture:self.videoParam];
    
    // BCD Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
            if (self.userType == CallUserAnchor) {
                // 主播接听
                // 申请会议
                //初始化会议
                NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
                self.meeting = meeting;
                //指定会议名
                meeting.name = [NSUUID UUID].UUIDString;
                meeting.actor = YES;
                //预订会议
                [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
                    //预订会议失败
                    if (error) {
                    }
                    
                    //预订会议成功
                    else {
                        dispatch_semaphore_signal(semaphore);
                    }
                }];
            }else{
                // 请求房间 id
                
            }
    
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NIMNetCallOption *option = [[NIMNetCallOption alloc]init];
        self.meeting.option = option;
        //指定 option 中的 videoCaptureParam 参数
        NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc] init];
        //清晰度
        param.preferredVideoQuality = NIMNetCallVideoQualityHigh;
        //裁剪类型 16:9
        param.videoCrop  = NIMNetCallVideoCrop16x9;
        //打开初始为前置摄像头
        param.startWithBackCamera = NO;
        option.videoCaptureParam = param;
        
        //加入会议
        [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:self.meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
            //加入会议失败
            if (error) {
            }
            //加入会议成功
            else
            {
                //获取当前通话 ID
                UInt64 currentNetcall = [[NIMAVChatSDK sharedSDK].netCallManager currentCallID];
                NSLog(@"%ld",currentNetcall);
                
            }
        }];
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    //离开当前多人会议
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.meeting];
}

# pragma mark - NIMNetCallManagerDelegate
//收到用户加入通知
- (void)onUserJoined:(NSString *)uid meeting:(NIMNetCallMeeting *)meeting
{
    //更新会议在线人数
}

//会议发生错误
- (void)onMeetingError:(NSError *)error meeting:(NIMNetCallMeeting *)meeting
{
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//远程YUV数据就绪回调
- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    //_remoteGLView 是 NTESGLView 类型  DEMO 提供 NTESGLView 类来渲染yuv数据
    [self.glView render:yuvData width:width height:height];
}

- (void)onLocalDisplayviewReady:(UIView *)displayView
{
    if (self.localPreView) {
        [self.localPreView removeFromSuperview];
    }
    self.localPreView = displayView;
    displayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.localVideoView addSubview:displayView];
}

- (IBAction)clickSmallPreview:(id)sender {
    [self switchPreView];
}

-(void)switchPreView{
    self.meInBig = !self.meInBig;
    UIView *big = self.meInBig? self.localPreView: self.glView;
    UIView *small = self.meInBig? self.glView: self.localPreView;
    [big removeFromSuperview];
    [big setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.localVideoView addSubview:big];
    [small removeFromSuperview];
    [small setFrame:self.smallVideoView.bounds];
    [self.smallVideoView addSubview:small];
}

@end
