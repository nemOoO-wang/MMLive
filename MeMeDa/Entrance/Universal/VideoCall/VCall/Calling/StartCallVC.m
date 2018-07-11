//
//  StartCallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "StartCallVC.h"
#import "VCallVC.h"
#import "NMFloatWindow.h"

@interface StartCallVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) NSNumber *trId;
@end

@implementation StartCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 请求开房
    NSDictionary *paramDic = @{@"userId":self.usrDic[@"id"], @"type":@2};;
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/makeCall" andParam:paramDic andSuccess:^(id data) {
        self.trId = data[@"id"];
    }];
    // init info
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.usrDic[@"headImg"]]];
    self.nameLabel.text = self.usrDic[@"nickname"];
}
- (IBAction)clickEndCal:(id)sender {
    NSDictionary *paramDic = @{@"trId":self.trId, @"userId":self.usrDic[@"id"]};
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/hangUp" andParam:paramDic andSuccess:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleResponse{
    // json
    NSString *json = self.callDataDic[@"message"];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    //初始化会议
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    //指定会议名
    meeting.name = dataDic[@"roomName"];
    meeting.actor = NO;
    
    VCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"calling"];
    vc.meeting = meeting;
    vc.userType = CallUserDefault;
    [NMFloatWindow keyFLoatWindow].frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2);
    [[NMFloatWindow keyFLoatWindow] setFullScreenWithoutAni:YES];
    [NMFloatWindow keyFLoatWindow].rootViewController = vc;
    [[NMFloatWindow keyFLoatWindow] show];
    [self dismissViewControllerAnimated:NO completion:nil];
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
