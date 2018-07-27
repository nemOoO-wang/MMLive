//
//  VCallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/27/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "VCallVC.h"
#import "VCallVC+Danmu.h"
#import "VCallVC+info.h"
#import "VCallVC+func.h"
// view
#import "NTESGLView.h"
#import "NMFloatWindow.h"
#import "NMRCCallMessage.h"


@interface VCallVC ()<NIMNetCallManagerDelegate>
@property (strong, nonatomic) NTESGLView *glView;
@property (nonatomic,strong) NIMNetCallVideoCaptureParam *videoParam;
@property (nonatomic,strong) NIMNetCallOption *netCallOption;
@property (nonatomic,strong) NSString *otherManTrId;
// views
@property (weak, nonatomic) IBOutlet UIImageView *secondImgView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImgView;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end

@implementation VCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // info data
    [self updateBalanceScheduled];
    // Dan mu
    [self enterDanmu];
    self.peopleCount = 0;
    
    [self initLocalCam];
    self.meeting.option = self.netCallOption;
    
    if (self.userType == CallUserAnchor) {
        NMRCCallMessage *msg = [[NMRCCallMessage alloc] init];
        msg.roomName = self.meeting.name;
        NSDictionary *dic = MDUserDic;
        msg.nickname = dic[@"nickname"];
        msg.headImg = dic[@"headImg"];
        msg.uId = dic[@"id"];
        msg.trId = self.calllMsg.trId;
        msg.code = @"2";
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PUSHSERVICE targetId:self.callerId content:msg pushContent:@"主播回应接听" pushData:nil success:^(long messageId) {
            
        } error:^(RCErrorCode nErrorCode, long messageId) {
            
        }];
    }
    
    //加入会议
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:self.meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        //加入会议失败
        if (error) {
        }
        //加入会议成功
        else
        {
            [[NIMAVChatSDK sharedSDK].netCallManager switchVideoQuality:NIMNetCallVideoQuality720pLevel];
            //开启扬声器
            [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:YES];
            [SVProgressHUD showSuccessWithStatus:@"进入房间成功"];
            // 初始化 lgview
            CGSize size = self.localVideoView.bounds.size;
            self.glView = [[NTESGLView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
            self.glView.userInteractionEnabled = NO;
            [self.localVideoView addSubview:self.glView];
            self.meInBig = NO;
            self.localPreView = [[UIView alloc] initWithFrame:self.smallVideoView.bounds];
        }
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    //离开当前多人会议
//    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.meeting];
}

# pragma mark - NIMNetCallManagerDelegate
//收到用户加入通知
- (void)onUserJoined:(NSString *)uid meeting:(NIMNetCallMeeting *)meeting
{
    //更新会议在线人数
    if (!self.otherManTrId) {
        self.otherManTrId = uid;
    }else{
        self.peopleCount++;
        self.peopleCountLabel.text = [NSString stringWithFormat:@"%ld 人正在偷听",self.peopleCount];
    }
    
}

// 用户离开
-(void)onUserLeft:(NSString *)uid meeting:(NIMNetCallMeeting *)meeting{
    if ([uid isEqualToString:self.otherManTrId]) {
        [SVProgressHUD showInfoWithStatus:@"对方挂断电话"];
        [self clickEndCall:nil];
    }
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
    if (self.localPreView) {
        [self.localPreView removeFromSuperview];
    }
    self.localPreView = displayView;
//    CGRect originFrame = self.localPreView.frame;
//    displayView.frame = originFrame;
    displayView.userInteractionEnabled = NO;
    if (self.meInBig) {
        displayView.frame = self.localVideoView.bounds;
        [self.localVideoView addSubview:displayView];
    }else{
        displayView.frame = self.smallVideoView.bounds;
        [self.smallVideoView addSubview:displayView];
    }
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
    
    //开始采集
    [[NIMAVChatSDK sharedSDK].netCallManager startVideoCapture:self.videoParam];  
}

-(NIMNetCallVideoCaptureParam *)videoParam{
    if (!_videoParam) {
        _videoParam = [[NIMNetCallVideoCaptureParam alloc] init];
        //清晰度
        _videoParam.preferredVideoQuality = NIMNetCallVideoQuality720pLevel;
//        _videoParam.preferredVideoQuality = NIMDocTranscodingQualityHigh;
        //裁剪类型 16:9
        _videoParam.videoCrop  = NIMNetCallVideoCrop16x9;
        //打开初始为前置摄像头
        _videoParam.startWithBackCamera = NO;
        // 高质量预览
        _videoParam.highPreviewQuality = YES;
        // fps
//        _videoParam.videoFrameRate = 25;
    }
    return _videoParam;
}

-(NIMNetCallOption *)netCallOption{
    if (!_netCallOption) {
        _netCallOption = [[NIMNetCallOption alloc]init];
        //指定 option 中的 videoCaptureParam 参数
        _netCallOption.videoCaptureParam = self.videoParam;
    }
    return _netCallOption;
}


-(void)beforeEndCall{
    [self.timer invalidate];
    [self quitDamnu];
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.meeting];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSDictionary *paramDic = @{@"trId":self.calllMsg.trId};
    [[BeeNet sharedInstance] requestWithType:Request_POST url:@"/chat/user/doneHangUp" param:paramDic success:^(id data) {
    } fail:^(NSString *message) {
    }];
}

-(void)setupUI{
    if (self.userType == CallUserDefault) {
        self.secondLabel.text = @"礼物";
        self.secondImgView.image = [UIImage imageNamed:@"liaotian_liwu"];
        self.thirdLabel.text = @"充值";
        self.thirdImgView.image = [UIImage imageNamed:@"liaotian_chongzhi"];
    }
}

# pragma mark - click
- (IBAction)clickEndCall:(id)sender {
    [self beforeEndCall];
    if (self.userType == CallUserDefault) {
        UserEndCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"user end"];
        [NMFloatWindow keyFLoatWindow].rootViewController = vc;

    }else{
        AnchorEndCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"anchor end"];
        [NMFloatWindow keyFLoatWindow].rootViewController = vc;
        
    }
//    [[NMFloatWindow keyFLoatWindow] dismiss];
}

- (IBAction)clickSmallalize:(id)sender {
//    if ([self.smallVideoView.subviews containsObject:self.glView]) {
//        [self switchPreView];
//    }
    [NMFloatWindow keyFLoatWindow].fullScreen = NO;
}

- (IBAction)clickSound:(id)sender {
    UIButton *btn = sender;
    BOOL mute = !btn.selected;
    btn.selected = mute;
//    //开启静音
//    [[NIMAVChatSDK sharedSDK].netCallManager setMute:mute];
    //指定所有远端用户是否对其静音
    [[NIMAVChatSDK sharedSDK].netCallManager setAudioSendMute:mute];
    // 背景色提示
    UIColor *bgc = mute? [UIColor colorWithHexString:@"807F7F" alpha:0.7]: [UIColor clearColor];
    [btn setBackgroundColor:bgc];
}

- (IBAction)clickCamera:(id)sender {
    UIButton *btn = sender;
    BOOL backCam = !btn.selected;
    btn.selected = backCam;
    //切换为前摄像头
    NIMNetCallCamera camType = backCam? NIMNetCallCameraBack: NIMNetCallCameraFront;
    [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:camType];
    // 背景色提示
    UIColor *bgc = backCam? [UIColor colorWithHexString:@"807F7F" alpha:0.7]: [UIColor clearColor];
    [btn setBackgroundColor:bgc];
}

-(void)switchPreView{
    self.meInBig = !self.meInBig;
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
    
    self.localPreView = [[NIMAVChatSDK sharedSDK].netCallManager localPreview];
}

-(void)didReceiveMemoryWarning{
    [self beforeEndCall];
}


@end
