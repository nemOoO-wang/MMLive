//
//  MessageListTVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MessageListTVC.h"
#import "UserListTableViewCell.h"
#import "UserInfoVC.h"


@interface MessageListTVC ()
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation MessageListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.listType == MessageTypeSearch) {
        // 搜索
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/indexSearch" andParam:self.searchDic andSuccess:^(id data) {
            self.dataArr = data[@"data"][@"content"];
            [self.tableView reloadData];
        }];
    }
    if (self.listType == MessageTypePeepMe) {
        // 看过我
        [self setTitle:@"谁看过我"];
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/whoLookMe" andParam:nil andSuccess:^(id data) {
            self.dataArr = data[@"data"];
            [self.tableView reloadData];
        }];
    }
    if (self.listType == MessageTypeCallLog) {
        // 通话记录
        [self setTitle:@"通话记录"];
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/inOut" andParam:nil andSuccess:^(id data) {
            self.dataArr = data[@"data"];
            [self.tableView reloadData];
        }];
    }
    if (self.listType == MessageTypeReservation) {
        // 预约
        [self setTitle:@"我的预约"];
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/sub/userAppointmentList" andParam:nil andSuccess:^(id data) {
            self.dataArr = data[@"data"];
            [self.tableView reloadData];
        }];
    }
    if (self.listType == MessageTypeFriendMsg) {
        // 好友
        [self setTitle:@"好友消息"];
//        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/sub/userAppointmentList" andParam:nil andSuccess:^(id data) {
//            self.dataArr = data[@"data"];
//            [self.tableView reloadData];
//        }];
    }
    if (self.listType == MessageTypeSysInfo) {
        // 通知
        [self setTitle:@"系统通知"];
//        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/sub/userAppointmentList" andParam:nil andSuccess:^(id data) {
//            self.dataArr = data[@"data"];
//            [self.tableView reloadData];
//        }];
    }
    if (self.listType == MessageTypeLahei) {
        // 拉黑
        [self setTitle:@"黑名单"];
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getMyBlackList" andParam:nil andSuccess:^(id data) {
            self.dataArr = data[@"data"];
            [self.tableView reloadData];
        }];
    }
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listType == MessageTypeLahei) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSDictionary *tmpDic = self.dataArr[indexPath.row];
            NSDictionary *param = @{@"userId":tmpDic[@"id"]};
            [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/deleteMyBlack" andParam:param andSuccess:^(id data) {
                NSMutableArray *tmpArr = [self.dataArr mutableCopy];
                [tmpArr removeObjectAtIndex:indexPath.row];
                self.dataArr = [tmpArr copy];
                [self.tableView reloadData];
            }];
        }];
        return @[action];
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListTableViewCell *cell;
    if (self.listType == MessageTypeSearch) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"log" forIndexPath:indexPath];
        cell.dataDic = self.dataArr[indexPath.row];
    }
    if (self.listType == MessageTypePeepMe) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"log" forIndexPath:indexPath];
        cell.dataDic = self.dataArr[indexPath.row];
    }
    if (self.listType == MessageTypeCallLog) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"log" forIndexPath:indexPath];
        cell.dataDic = self.dataArr[indexPath.row];
    }
    if (self.listType == MessageTypeLahei) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lahei" forIndexPath:indexPath];
        cell.dataDic = self.dataArr[indexPath.row];
    }
    return cell;
}

# pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *uDic = self.dataArr[indexPath.row];
    if (self.listType == MessageTypeCallLog) {
        uDic = uDic[@"fromId"];
    }
    // user detail
    UserInfoVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"user detail"];
    vc.dataDic = uDic;
    [self.navigationController pushViewController:vc animated:YES];
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
