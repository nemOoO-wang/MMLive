//
//  UserListTableViewCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/11/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UserListTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIWindow+NMCurrent.h"
#import "StartCallVC.h"
#import "VCallVC.h"
//#import <NIMSDK/NIMSDK.h>
//#import <NIMAVChat/NIMAVChat.h>


@interface UserListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *psLabel;

@end

@implementation UserListTableViewCell

-(void)setMagaDic:(NSDictionary *)magaDic{
    _magaDic = magaDic;
    if ([MDUserDic[@"gender"] integerValue] == 1) {
        // 男
        self.dataDic = magaDic[@"toId"];
    }else{
        // 主播
        self.dataDic = magaDic[@"fromId"];
    }
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:dataDic[@"headImg"]]];
    self.nameLabel.text = dataDic[@"nickname"];
    self.psLabel.text = dataDic[@"mark"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickVideoCall:(id)sender {
    if ([self.dataDic[@"anchorState"] integerValue] != 2) {
        [SVProgressHUD showWithStatus:@"主播未认证"];
    }else{
        StartCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"start call"];
        vc.usrDic = self.dataDic;
        UIViewController *current = [[[UIApplication sharedApplication] keyWindow] getCurrentViewController];
        [current presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)clickCancelReserve:(id)sender {
    NSDictionary *param = @{@"subId":self.magaDic[@"id"]};
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/sub/deleteAppoint" andParam:param andSuccess:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Message Need Refresh" object:nil];
    }];
}
- (IBAction)clickChat:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Want To Call" object:self.dataDic];
}

- (IBAction)clickVideoCallBack:(id)sender {
    if ([self.dataDic[@"anchorState"] integerValue] != 2) {
        [SVProgressHUD showWithStatus:@"主播未认证"];
    }else{
        // 开房
        //初始化会议
        NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
        //指定会议名
        meeting.name = [NSUUID UUID].UUIDString;
        meeting.actor = YES;
        // 视频聊天
        [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
            //预订会议失败
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"开房失败"];
            }
            //预订会议成功
            else {
                // 调用后台接口，自动删除此条预约记录
                NSDictionary *dic = @{@"type":@2, @"userId":self.dataDic[@"id"], @"roomName":meeting.name, @"subId":self.magaDic[@"id"]};
                [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/ringBack" andParam:dic andSuccess:^(id data) {
                    // new vc
                    VCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"calling"];
                    vc.userType = CallUserAnchor;
                    vc.meeting = meeting;
                    vc.callerId = [self.dataDic[@"id"] stringValue];
                    vc.directRingBack = YES;
                    vc.subId = self.magaDic[@"id"];
                    vc.trId = [data[@"data"][@"id"] stringValue];
                    [[NMFloatWindow keyFLoatWindow] setFullScreenWithoutAni:YES];
                    [NMFloatWindow keyFLoatWindow].frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                    [NMFloatWindow keyFLoatWindow].rootViewController = vc;
                    [[NMFloatWindow keyFLoatWindow] show];
                    [SVProgressHUD dismiss];
                }];
            }
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
