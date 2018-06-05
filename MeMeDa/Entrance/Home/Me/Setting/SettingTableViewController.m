//
//  SettingTableViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SettingTableViewController.h"

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
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.blurView removeFromSuperview];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        // 新访客
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        // 文字通讯
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
            
        // 语音通话
        case 11:
            
            break;
        case 12:
            
            break;
        case 13:
            
            break;
            
        // 视频通话
        case 16:
            
            break;
        case 17:
            
            break;
        case 18:
            
            break;
            
        // other
        case 20:
            
            break;
        case 21:
            
            break;
        case 22:
            
            break;
            
        case 24:
            
            break;
        case 25:
            // 退出
            
            break;
            
        default:
            break;
    }
    
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
