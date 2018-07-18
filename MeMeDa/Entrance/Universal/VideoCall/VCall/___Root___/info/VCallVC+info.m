//
//  VCallVC+info.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/13/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "VCallVC+info.h"

@implementation VCallVC (info)

-(void)updateBalanceScheduled{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fireTimer) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)fireTimer{
    if (self.userType == CallUserDefault) {
        NSDictionary *paramDic = @{@"trId":self.trId};
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/userGetNowBlance" andParam:paramDic andSuccess:^(id data) {
            NSInteger balance = [data[@"data"][@"balance"] integerValue];
            self.balanceLabel.text = [NSString stringWithFormat:@"我的余额 %ld", balance];
        }];
    }
}

@end
