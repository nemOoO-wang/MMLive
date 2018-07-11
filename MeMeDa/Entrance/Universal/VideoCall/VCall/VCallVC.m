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
#import "NMFloatWindow.h"


@interface VCallVC ()<NIMNetCallManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *localVideoView;
@property (nonatomic,strong) UIView *localPreView;
@property (nonatomic,strong) NIMNetCallVideoCaptureParam *videoParam;
@property (strong, nonatomic) NTESGLView *glView;
@property (nonatomic,assign) BOOL meInBig;
@property (nonatomic,strong) NIMNetCallOption *netCallOption;


@end

@implementation VCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocalCam];
    self.meeting.option = self.netCallOption;
    
    //加入会议
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:self.meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        //加入会议失败
        if (error) {
        }
        //加入会议成功
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"进入房间成功"];
            //初始化采集参数
            self.videoParam = [[NIMNetCallVideoCaptureParam alloc]init];
            //开始采集
            [[NIMAVChatSDK sharedSDK].netCallManager startVideoCapture:self.videoParam];
            // 初始化 lgview
            CGSize size = self.smallVideoView.bounds.size;
            self.glView = [[NTESGLView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
            self.glView.userInteractionEnabled = YES;
            [self.smallVideoView addSubview:self.glView];
            self.meInBig = NO;
            self.localPreView = [[UIView alloc] initWithFrame:self.smallVideoView.bounds];
        }
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
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
    [self clickEndCall:nil];
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
    CGRect originFrame = self.localPreView.frame;
    if (self.localPreView) {
        [self.localPreView removeFromSuperview];
    }
    self.localPreView = displayView;
    displayView.frame = originFrame;
    displayView.userInteractionEnabled = NO;
    if (self.meInBig) {
        [self.localVideoView addSubview:displayView];
    }else{
        [self.smallVideoView addSubview:displayView];
    }
}

- (IBAction)clickSmallPreview:(id)sender {
    [self switchPreView];
}

-(void)setMeInBig:(BOOL)meInBig{
    _meInBig = meInBig;
    UIView *big = self.meInBig? self.localPreView: self.glView;
    UIView *small = self.meInBig? self.glView: self.localPreView;
    [big removeFromSuperview];
    [big setFrame:[NMFloatWindow keyFLoatWindow].bounds];
    [self.localVideoView addSubview:big];
    [small removeFromSuperview];
    [small setFrame:self.smallVideoView.bounds];
    [self.smallVideoView addSubview:small];
}

-(void)switchPreView{
    self.meInBig = !self.meInBig;
}

-(void)initLocalCam{
    // 本地摄像头
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
}

-(NIMNetCallOption *)netCallOption{
    if (!_netCallOption) {
        NIMNetCallOption *option = [[NIMNetCallOption alloc]init];
        //指定 option 中的 videoCaptureParam 参数
        NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc] init];
        //清晰度
        param.preferredVideoQuality = NIMNetCallVideoQualityHigh;
        //裁剪类型 16:9
        param.videoCrop  = NIMNetCallVideoCrop16x9;
        //打开初始为前置摄像头
        param.startWithBackCamera = NO;
        option.videoCaptureParam = param;
    }
    return _netCallOption;
}

-(void)beforeEndCall{
    NSDictionary *paramDic = @{@"trId":self.trId};
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/doneHangUp" andParam:paramDic andSuccess:nil];
}

# pragma mark - click
- (IBAction)clickEndCall:(id)sender {
    [self beforeEndCall];
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.meeting];
    [NMFloatWindow keyFLoatWindow].rootViewController = nil;
    [[NMFloatWindow keyFLoatWindow] dismiss];
}

- (IBAction)clickSmallalize:(id)sender {
//    if ([self.smallVideoView.subviews containsObject:self.glView]) {
//        [self switchPreView];
//    }
    self.menuContainerView.alpha = 0;
    self.smallVideoView.alpha = 0;
    [NMFloatWindow keyFLoatWindow].fullScreen = NO;
}

-(void)didReceiveMemoryWarning{
    [self beforeEndCall];
}

@end
