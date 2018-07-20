//
//  BeCalledVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "BeCalledVC.h"
#import "VCallVC.h"
#import "NMFloatWindow.h"

@interface BeCalledVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BeCalledVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *json = self.callDataDic[@"message"];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    self.nameLabel.text = dataDic[@"userName"];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
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
    [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        //预订会议失败
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"开房失败"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        //预订会议成功
        else {
            // json
            NSString *json = self.callDataDic[@"message"];
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            // post
            NSDictionary *paramDic = @{@"trId":dataDic[@"trId"], @"accId":dataDic[@"userAccid"], @"roomName":meeting.name};
            
            
            [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/anchorAnswer" andParam:paramDic andSuccess:^(id data) {
                VCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"calling"];
                vc.userType = CallUserAnchor;
                // json
                NSString *json = self.callDataDic[@"message"];
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                vc.trId = dataDic[@"trId"];
                vc.meeting = meeting;
                [NMFloatWindow keyFLoatWindow].frame = [UIScreen mainScreen].bounds;
                [NMFloatWindow keyFLoatWindow].fullScreen = YES;
                [NMFloatWindow keyFLoatWindow].rootViewController = vc;
                [self dismissViewControllerAnimated:NO completion:nil];
                [SVProgressHUD dismiss];
            }];
        }
    }];
}
- (IBAction)clickRefuse:(id)sender {
    // json
    NSString *json = self.callDataDic[@"message"];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
    self.nameLabel.text = dataDic[@"userName"];
    NSDictionary *paramDic = @{@"trId":dataDic[@"trId"]};
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/doneHangUp" andParam:paramDic andSuccess:nil];
    [[NMFloatWindow keyFLoatWindow] dismiss];
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
