//
//  ChatVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/24/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ChatVC.h"
#import "ChatTBCell.h"
#import <RongCloudIM/RongIMLib/RongIMLib.h>


@interface ChatVC ()<UITableViewDelegate, UITableViewDataSource,
                    RCIMClientReceiveMessageDelegate,
                    UITextFieldDelegate>
@property (nonatomic,strong) RCUserInfo *myUserInfo;
@property (nonatomic,strong) NSString *friendId;
@property (nonatomic,strong) NSArray *dialogHistoryArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end


@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 50;
    
    [[RCIMClient sharedRCIMClient] connectWithToken:RCUserToken
                                            success:^(NSString *userId) {
                                                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                            } error:^(RCConnectErrorCode status) {
                                                NSLog(@"登陆的错误码为:%ld", (long)status);
                                            } tokenIncorrect:^{
                                                //token过期或者不正确。
                                                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                                NSLog(@"token错误");
                                            }];
    // 设置消息接收监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    // 本地历史
    self.dialogHistoryArr = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:self.friendId count:20];
    // 远程历史
}

-(NSString *)friendId{
    if(!_friendId){
        NSInteger targetIdInt = [[self.friendUserDic objectForKey:@"id"] integerValue];
        _friendId = [NSString stringWithFormat:@"%ld",targetIdInt];
    }
    return _friendId;
}

-(RCUserInfo *)myUserInfo{
    if(!_myUserInfo){
        NSDictionary *userDic = MDUserDic;
        NSInteger idInt = [[userDic objectForKey:@"id"] integerValue];
        NSString *targitId = [NSString stringWithFormat:@"%ld",idInt];
        _myUserInfo = [[RCUserInfo alloc] initWithUserId:targitId name:userDic[@"nickname"] portrait:userDic[@"headImg"]];
    }
    return _myUserInfo;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - <text field delegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // content
//    RCMessageContent *mContent = [[RCMessageContent alloc] init];
//    //    mContent.mentionedInfo;
//    [mContent setRawJSONData: [self.inputTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    RCTextMessage *mContent = [RCTextMessage messageWithContent:self.inputTextField.text];
    mContent.senderUserInfo = self.myUserInfo;
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.friendId content:mContent pushContent:nil pushData:nil success:^(long messageId) {
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
    }];
    return YES;
}

# pragma mark - <UITableViewDataSource>

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCMessage *msg = self.dialogHistoryArr[indexPath.row];
    ChatTBCell *cell;
    if([msg.senderUserId isEqualToString:self.friendId]){
        // you
        cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
        cell.userDic = self.friendUserDic;
    }else{
        // me
        cell = [tableView dequeueReusableCellWithIdentifier:@"me"];
        cell.userDic = MDUserDic;
    }
    // text message
    if ([msg.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)msg.content;
        cell.content = testMessage.content;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dialogHistoryArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCMessage *msg = self.dialogHistoryArr[indexPath.row];
    if ([msg.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)msg.content;
        NSString *str = testMessage.content;
        CGSize size = [str boundingRectWithSize:CGSizeMake(207, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if(size.height<60){
            return 60;
        }else{
            return size.height+20;
        }
    }
    return 100;
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
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
    }
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}


@end
