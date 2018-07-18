//
//  VCallVC+func.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/18/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "VCallVC+func.h"
#import "BuyCoinVC.h"


@implementation VCallVC (func)

- (IBAction)clickBtn2:(id)sender {
    if (self.userType == CallUserAnchor) {
        // 对方余额
        NSDictionary *param = @{@"trId":self.trId};
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getLookBlance" andParam:param andSuccess:^(id data) {
            NSString *info = [NSString stringWithFormat:@"对方余额: %@",[data[@"data"] stringValue]];
            [[NMFloatWindow keyFLoatWindow] handleasKeywindow:^{
                [SVProgressHUD showInfoWithStatus:info];
            }];
        }];
    }else{
        // 礼物
    }
}

- (IBAction)clickBtn3:(id)sender {
    if (self.userType == CallUserAnchor) {
        // 预约列表
    }else{
        // 充值
        BuyCoinVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"topup"];
        vc.customBarHeight = 44;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


@end
