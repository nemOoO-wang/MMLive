//
//  VCallVC+Danmu.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "VCallVC+Danmu.h"


@implementation VCallVC (Danmu)

# pragma mark - Danmu
-(void)enterDanmu{
    // 设置消息接收监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceived:) name:@"RCRecieve" object:nil];
//    if (self.userType == CallUserAnchor) {
    [[RCIMClient sharedRCIMClient] joinChatRoom:self.meeting.name messageCount:0 success:^{
        
    } error:^(RCErrorCode status) {
        [SVProgressHUD showErrorWithStatus:@"进入房间失败"];
    }];
}

-(void)quitDamnu{
    [[RCIMClient sharedRCIMClient] quitChatRoom:self.meeting.name success:^{
        
    } error:^(RCErrorCode status) {
        [SVProgressHUD showErrorWithStatus:@"退出房间失败"];
    }];
}

-(void)refreshMsg{
    self.danmuArr = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_CHATROOM targetId:self.meeting.name count:20];
    self.danmuView.dataArr = self.danmuArr;
}

- (IBAction)clickSendMsg:(id)sender {
    UIAlertController *txtAlert = [UIAlertController alertControllerWithTitle:@"弹幕" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    // txtfld
    [txtAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入弹幕";
    }];
    // confirm
    UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = [txtAlert.textFields firstObject].text;
        if (text && ![text isEqualToString:@""]) {
            BarrageMessage *msg = [[BarrageMessage alloc] init];
            // msg
            msg.senderUserInfo = [self genMeInfo];
            msg.name = MDUserDic[@"nickname"];
            msg.danmu = text;
            msg.img = @"";
            
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_CHATROOM targetId:self.meeting.name content:msg pushContent:nil pushData:nil success:^(long messageId) {
            } error:^(RCErrorCode nErrorCode, long messageId) {
            }];
            
//            NSString *rmPuthContent = [NSString stringWithFormat:@"%@: %@",MDUserDic[@"nickname"], text];
//            RCTextMessage *mContent = [RCTextMessage messageWithContent:rmPuthContent];
//            mContent.senderUserInfo = [self genMeInfo];
//            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_CHATROOM targetId:self.meeting.name content:mContent pushContent:nil pushData:nil success:^(long messageId) {
//
//            } error:^(RCErrorCode nErrorCode, long messageId) {
//
//            }];
            // 这里插入
            
            [self refreshMsg];
        }
    }];
    [txtAlert addAction:confirmAct];
    // cancel
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [txtAlert addAction:cancel];
    // present
    [self presentViewController:txtAlert animated:YES completion:nil];
}

-(RCUserInfo *)genMeInfo{
    NSDictionary *userDic = MDUserDic;
    NSInteger idInt = [[userDic objectForKey:@"id"] integerValue];
    NSString *targitId = [NSString stringWithFormat:@"%ld",idInt];
    RCUserInfo *myUserInfo = [[RCUserInfo alloc] initWithUserId:targitId name:userDic[@"nickname"] portrait:userDic[@"headImg"]];
    return myUserInfo;
}



# pragma mark - delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}


- (void)onReceived:(NSNotification *)notification{
    RCMessage *message = notification.object;
    if (message.conversationType == ConversationType_CHATROOM && [message.targetId isEqualToString:self.meeting.name]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self refreshMsg];
        });
    }
}

@end
