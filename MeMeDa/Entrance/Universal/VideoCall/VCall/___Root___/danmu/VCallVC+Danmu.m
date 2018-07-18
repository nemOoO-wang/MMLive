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
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
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
            NSString *rmPuthContent = [NSString stringWithFormat:@"%@: %@",MDUserDic[@"nickname"], text];
            RCTextMessage *mContent = [RCTextMessage messageWithContent:rmPuthContent];
            mContent.senderUserInfo = [self genMeInfo];
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_CHATROOM targetId:self.meeting.name content:mContent pushContent:nil pushData:nil success:^(long messageId) {
                
            } error:^(RCErrorCode nErrorCode, long messageId) {
                
            }];
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

# pragma mark - <RCIMClientReceiveMessageDelegate>
/*!
 @param message     当前接收到的消息
 @param nLeft       还剩余的未接收的消息数，left>=0
 @param object      消息监听设置的key值
 
 @discussion 如果您设置了IMlib消息监听之后，SDK在接收到消息时候会执行此方法。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 object为您在设置消息接收监听时的key值。
 */
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", textMessage.content);
        //        NSMutableArray *tmpArr = [self.dialogHistoryArr mutableCopy];
        //        [tmpArr addObject:textMessage];
        //        self.dialogHistoryArr = [tmpArr copy];
        //        dispatch_sync(dispatch_get_main_queue(), ^{
        ////            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
        //            [self.tableView reloadData];
        //        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self refreshMsg];
        });
    }
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}

@end
