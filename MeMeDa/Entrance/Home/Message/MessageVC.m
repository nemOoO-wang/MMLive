//
//  MessageVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MessageVC.h"
#import "UserInfoVC.h"
#import "MessageListTVC.h"
//#import <NIMSDK/NIMSDK.h>
#import <RongIMLib/RongIMLib.h>
#import "UserListTableViewCell.h"


@interface MessageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *idArr;
@property (nonatomic,strong) NSArray *dataArr;


@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRootTable];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)setUpRootTable{
    //    NSString *uid = [MDUserDic[@"id"] stringValue];
    //    NIMSession *session = [NIMSession session:uid type:NIMSessionTypeChatroom];
    //    NIMHistoryMessageSearchOption *opt = [[NIMHistoryMessageSearchOption alloc] init];
    //    opt.limit = 20;
    NSDictionary *paramDic = @{@"page":@0, @"size":@20};
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/meFollowList" andParam:paramDic andSuccess:^(id data) {
        // origin
        NSArray *tmpArr = data[@"data"];
        NSMutableArray *originIdArr = [[NSMutableArray alloc] init];
        [originIdArr addObject:MDUserDic[@"id"]];
        [tmpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            [originIdArr addObject:dic[@"id"]];
        }];
        // rc log
        NSArray *logArr = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]];
        NSMutableArray *idArr = [[NSMutableArray alloc] init];
        [logArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RCConversation *conversation = (RCConversation *)obj;
            NSNumber *n = @([conversation.targetId integerValue]);
            if (![originIdArr containsObject:n]) {
                [idArr addObject:n];
            }
        }];
        self.idArr = [idArr copy];
        if (self.idArr.count>0) {
            NSMutableArray *dataArr = [[NSMutableArray alloc] init];
            [self.idArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber *uId = (NSNumber *)obj;
                [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/userDetail" andParam:@{@"userId":uId} andSuccess:^(id data) {
                    if (data[@"data"]) {
                        NSDictionary *tmpData = data[@"data"][@"user"];
                        [dataArr addObject:tmpData];
                        if (idx == self.idArr.count-1) {
                            self.dataArr = [dataArr copy];
                            [self.tableView reloadData];
                        }
                    }
                }];
            }];
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

# pragma mark - click
// 好友消息
- (IBAction)clickFriends:(id)sender {
    [self performSegueWithIdentifier:@"table" sender:@5];
}

// 谁看过我
- (IBAction)clickPeeped:(id)sender {
    [self performSegueWithIdentifier:@"table" sender:@1];
}

// 系统通知
- (IBAction)clickNoti:(id)sender {
    [self performSegueWithIdentifier:@"table" sender:@6];
}

// 通话记录
- (IBAction)clickCallLog:(id)sender {
    [self performSegueWithIdentifier:@"table" sender:@3];
}

// 我的预约
- (IBAction)clickReservation:(id)sender {
    [self performSegueWithIdentifier:@"table" sender:@4];
}

# pragma mark - prepare segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"table"]) {
        MessageListTVC *vc = [segue destinationViewController];
        switch ([sender integerValue]) {
            case 1:
                vc.listType = MessageTypePeepMe;
                break;
            case 3:
                vc.listType = MessageTypeCallLog;
                break;
            case 4:
                vc.listType = MessageTypeReservation;
                break;
            case 5:
                vc.listType = MessageTypeFriendMsg;
                break;
            case 6:
                vc.listType = MessageTypeSysInfo;
                break;
                
            default:
                break;
        }
    }
}

# pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:@"table" sender:nil];
    if (indexPath.row == 0) {
        
    }else{
        // user detail
        UserInfoVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"user detail"];
        NSDictionary *uDic = self.dataArr[indexPath.row-1];
        vc.dataDic = uDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

# pragma mark - <UITableViewDataSource>
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"system"];
    }
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"log"];
    cell.dataDic = self.dataArr[indexPath.row-1];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
