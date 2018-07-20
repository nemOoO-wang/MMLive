//
//  FollowerTVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/11/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "FollowerTVC.h"
#import "UserListTableViewCell.h"
#import <MJRefresh.h>


@interface FollowerTVC ()

@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign) NSInteger page;

@end

@implementation FollowerTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    // refresh
//    self.tableView.header = [mjrefresh]
    
    // hide line
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString *baseUrl = self.type == NMFollowerTypeMyFollow? @"/chat/user/meFollowList": @"/chat/user/followMeList";
    NSDictionary *paramDic = @{@"page":@(self.page), @"size":@20};
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:baseUrl andParam:paramDic andSuccess:^(id data) {
        self.dataArr = data[@"data"];
        [self.tableView reloadData];
    }];
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
    // online. offLine
    UserListTableViewCell *cell;
    if ([self.dataArr[indexPath.row][@"onlineState"] integerValue] == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"online" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"offLine" forIndexPath:indexPath];
    }
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
