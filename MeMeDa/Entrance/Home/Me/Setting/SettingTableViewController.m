//
//  SettingTableViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SettingsBtnTblCell.h"
#import <NIMSDK/NIMSDK.h>
#import "MiPushSDK.h"


@interface SettingTableViewController ()

@property (nonatomic,strong) UIVisualEffectView *blurView;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //always fill the view
    self.blurView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.navigationController.view insertSubview:self.blurView atIndex:1];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.blurView removeFromSuperview];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 19) {
        // other
        switch (indexPath.row) {
            case 20:
                
                break;
            case 21:
                
                break;
            case 22:
                
                break;
                
            case 24:
                
                break;
            case 25:
                [self quit];
                break;
                
            default:
                break;
        }
    }
    
}

-(NSIndexPath *)arrIndexOfIndexpath:(NSInteger)originRow{
    NSInteger section = 0;
    NSInteger row = 0;
    switch (originRow) {
            // 新访客
        case 1:
            section = 0;
            row = 0;
            break;
        case 2:
            section = 0;
            row = 1;
            break;
        case 3:
            section = 0;
            row = 2;
            break;
            
            // 文字通讯
        case 6:
            section = 1;
            row = 0;
            break;
        case 7:
            section = 1;
            row = 1;
            break;
        case 8:
            section = 1;
            row = 2;
            break;
            
            // 语音通话
        case 11:
            section = 2;
            row = 0;
            break;
        case 12:
            section = 2;
            row = 1;
            break;
        case 13:
            section = 2;
            row = 2;
            break;
            
            // 视频通话
        case 16:
            section = 3;
            row = 0;
            break;
        case 17:
            section = 3;
            row = 1;
            break;
        case 18:
            section = 3;
            row = 2;
            break;
            
        default:
            section = 4;
            row = 0;
            break;
    }
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(void)quit{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    NSString *acid = [dic[@"id"] stringValue];
    [MiPushSDK unsetAccount:acid];
    // 退出
    [self.tabBarController dismissViewControllerAnimated:YES completion:^{}];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RCToken"];
    //                [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/logout" andParam:nil andSuccess:^(id data) {
    //                }];
    // log out 网易云
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
    }];
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
