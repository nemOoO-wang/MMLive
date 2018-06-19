//
//  EditMeRecordAudio.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/6/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "EditMeRecordAudio.h"
#import <AVFoundation/AVFoundation.h>


@interface EditMeRecordAudio ()<AVAudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) AVAudioPlayer *player;

@property (nonatomic,strong) AVAudioRecorder *recoder;
@property (nonatomic,strong) NSURL *audioUrl;

@end

@implementation EditMeRecordAudio

- (void)viewDidLoad {
    [super viewDidLoad];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"myRecord.m4a"];
    NSURL *pathUrl = [NSURL fileURLWithPath:path];
    self.audioUrl = pathUrl;
    NSError *err = nil;
    NSDictionary *settings = @{AVEncoderAudioQualityKey:@(AVAudioQualityMedium),                               AVFormatIDKey:@(kAudioFormatMPEG4AAC), AVNumberOfChannelsKey:@2, AVSampleRateKey: @12000,AVLinearPCMIsFloatKey: @(YES),AVLinearPCMBitDepthKey:@8};
    self.recoder = [[AVAudioRecorder alloc] initWithURL:pathUrl settings:settings error:&err];
    if (err) {
        NSLog(@"创建录音机对象时发生错误，错误信息：%@",err.localizedDescription);
    }
    self.recoder.delegate = self;
    // play btn
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [playBtn setTitle:@"▷" forState:UIControlStateNormal];
    [playBtn.titleLabel setFont:[UIFont systemFontOfSize:25]];
    [playBtn setBackgroundColor:[UIColor colorWithHexString:@"4EADFF"]];
    CGPoint b = self.btn.center;
    playBtn.frame = CGRectMake(SCREEN_WIDTH/2, b.y-200, 0, 0);
    playBtn.layer.cornerRadius = 0;
    playBtn.clipsToBounds = YES;
    self.playBtn = playBtn;
    [self.playBtn addTarget:self action:@selector(playLogVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
}

-(void)playLogVideo{
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioUrl error:nil];
    [self.player play];
}

- (IBAction)clickDown:(id)sender {
    [self.recoder prepareToRecord];
    [self.recoder deleteRecording];
    if (![self.recoder isRecording]){
        [self.recoder record];
    }
    [self.btn setBackgroundColor:[UIColor colorWithHexString:@"4AEA45"]];
}
- (IBAction)endClick:(id)sender {
    [self.recoder stop];
    [self.btn setBackgroundColor:[UIColor colorWithHexString:@"FF7799"]];
    CGPoint b = self.btn.center;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:10 initialSpringVelocity:30 options:UIViewAnimationOptionCurveLinear animations:^{
        self.playBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, b.y-250, 100, 100);
        self.playBtn.layer.cornerRadius = 50;
    } completion:^(BOOL finished) {
        
    }];
}

# pragma mark - <Delegate>
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (flag) {
        if (self.recorded) {
            self.recorded(self.audioUrl);
        }
        
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
