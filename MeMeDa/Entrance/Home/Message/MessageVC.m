//
//  MessageVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MessageVC.h"
#import "MessageListTVC.h"


@interface MessageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

// 谁看过我
- (IBAction)clickPeeped:(id)sender {
    [self performSegueWithIdentifier:@"table" sender:@1];
}

// 系统通知
- (IBAction)clickNoti:(id)sender {
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
                
            default:
                break;
        }
    }
}

# pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:@"table" sender:nil];
}

# pragma mark - <UITableViewDataSource>
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"system"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
