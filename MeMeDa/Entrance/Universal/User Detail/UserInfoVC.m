
//
//  UserInfoVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoPopMenuVC.h"
#import "UserInfoScrollBannerView.h"
#import "BorderAndTransLabel.h"
#import "NMLoginButton.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>


@interface UserInfoVC ()
// tool view
@property (weak, nonatomic) IBOutlet UserInfoScrollBannerView *bannerScrollViedw;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *coverView;
@property (weak, nonatomic) IBOutlet UIScrollView *guestScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerTopConstraint;
// basic view
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet BorderAndTransLabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlienLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pr1CountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pr2CountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pr3CountLabel;
@property (weak, nonatomic) IBOutlet NMLoginButton *followBtn;
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;
// data
@property (nonatomic,strong) NSString *audioUrlStr;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    // update view
    self.nameLabel.text = self.dataDic[@"nickname"];
    self.jobLabel.text = self.dataDic[@"profession"];
    self.cityLabel.text = self.dataDic[@"cityName"];
    self.descriptionLabel.text = self.dataDic[@"introduction"];
    self.priceLabel.text = [NSString stringWithFormat:@"%ld币/分钟",[self.dataDic[@"price"] integerValue]];
    // online
    NSString *online = [self.dataDic[@"onlineState"] integerValue] == 1? @"在线": @"离线";
    self.onlienLabel.text = online;
    // old
    self.oldLabel.text = [NSString stringWithFormat:@"%ld岁",[self.dataDic[@"age"] integerValue]];
    // voice
    if (self.dataDic[@"voice"]) {
        self.audioUrlStr = self.dataDic[@"voice"];
    }
    // gender
    if ([self.dataDic[@"gender"] integerValue] == 1) {
        [self.genderImgView setImage:[UIImage imageNamed:@"icon_nan2"]];
    }else{
        [self.genderImgView setImage:[UIImage imageNamed:@"icon_nv2"]];
    }
    // imgs
      // vedio: https://stackoverflow.com/questions/32368751/implementing-video-view-in-the-storyboard
    self.bannerScrollViedw.videoUrlStr = self.dataDic[@"video"];
    self.bannerScrollViedw.videoImgUrlStr = self.dataDic[@"vedioImg"];
    NSString *jsonStr = self.dataDic[@"imgs"];
    NSArray *imgUrlArr = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    [self.bannerScrollViedw setImgArr:imgUrlArr];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    // other data
    NSNumber *uId = dataDic[@"id"];
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/userDetail" andParam:@{@"userId":uId} andSuccess:^(id data) {
        NSDictionary *tmpData = data[@"data"];
        // gift
        if (tmpData[@"giftCounts"]) {
//            self.pr1CountLabel.text = @"X0";
//            self.pr2CountLabel.text = @"X0";
//            self.pr3CountLabel.text = @"X0";
        }
        // 访客
        NSArray *recentArr = tmpData[@"recent"];
        [self addToScrollViewWithUsers:recentArr];
        // 关注
        if (![tmpData[@"isFllow"] boolValue]) {
            //未关注
            [self.followBtn setTitle:@"未关注" forState:UIControlStateNormal];
        }
        
    }];
}

// add img to scroll view
-(void)addToScrollViewWithUsers:(NSArray *)imgArr{
    if (!imgArr || imgArr.count<=0) {
        return;
    }
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.clipsToBounds = YES;
        imgView.layer.cornerRadius = 17.5;
        imgView.frame = CGRectMake(49*i+14, 0, 35, 35);
        [self.guestScrollView addSubview:imgView];
        // load head img
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[i][@"headImg"]]];
    }
    self.guestScrollView.contentSize = CGSizeMake(49*imgArr.count+14, 35);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"menu"]) {
        UserInfoPopMenuVC *vc = [segue destinationViewController];
        vc.coverView = self.coverView;
        [UIView animateWithDuration:0.5 animations:^{
            self.coverView.alpha = 0.5;
        }];
    }
}

# pragma mark - click
- (IBAction)clickAudioView:(id)sender {
    if (self.audioPlayer) {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.audioUrlStr] error:nil];
    }
    [self.audioPlayer play];
}
- (IBAction)clickFollow:(id)sender {
    NSNumber *uid = self.dataDic[@"id"];
    NSDictionary *paramDic = @{@"userId":uid};
    if ([[self.followBtn titleForState:UIControlStateNormal] isEqualToString:@"已关注"]) {
        // 取消 /chat/user/disFollow
        [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/disFollow" andParam:paramDic andSuccess:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.followBtn setTitle:@"未关注" forState:UIControlStateNormal];
        }];
    }else{
        // 关注 /chat/user/follow
        [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/follow" andParam:paramDic andSuccess:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }];
    }
}
@end
