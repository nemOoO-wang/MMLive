//
//  MeCenterViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MeCenterViewController.h"
#import "HittestView.h"
#import "MyFollowVC.h"
#import "SetCoinVC.h"
#import <UIImageView+WebCache.h>


@interface MeCenterViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) HittestView *hittestView;

@property (weak, nonatomic) IBOutlet UIButton *ComposeBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UILabel *myFansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *myFollowCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authState;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end

@implementation MeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    // 用户字典
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    // 男用户不显示认证
    if ([userDic[@"gender"] integerValue] == 1) {
        self.authState.hidden = YES;
    }
    // 关注数
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getMeFollowCount" andParam:nil andSuccess:^(id data) {
        self.myFollowCountLabel.text = [NSString stringWithFormat:@"%ld",[data[@"data"] integerValue]];
    }];
    // 粉丝数
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getFollowMeCount" andParam:nil andSuccess:^(id data) {
        self.myFansCountLabel.text = [NSString stringWithFormat:@"%ld",[data[@"data"] integerValue]];
    }];
    // 余额
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getSelfBlance" andParam:nil andSuccess:^(id data) {
        self.myBalanceLabel.text = [NSString stringWithFormat:@"%ld",[data[@"data"] integerValue]];
    }];
    // 昵称
    self.nickNameLabel.text = userDic[@"nickname"];
    // 认证状态 0未认证 1认证中 2认证通过 3认证失败
    NSInteger authIndex = [userDic[@"anchorState"] integerValue];
    switch (authIndex) {
        case 0:
            self.authState.text = @"未认证";
            break;
        case 1:
            self.authState.text = @"认证中";
            break;
        case 2:
            self.authState.text = @"认证通过";
            break;
        case 3:
            self.authState.text = @"认证失败";
            break;
            
        default:
            break;
    }
    // head
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:userDic[@"headImg"]]];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL hidden = [viewController isEqual:self];
    [navigationController setNavigationBarHidden:hidden animated:YES];
}

//-(void)viewDidDisappear:(BOOL)animated{
//    [self.hittestView removeFromSuperview];
//}
//-(void)viewDidAppear:(BOOL)animated{
//    self.hittestView = [[HittestView alloc] initInController:self];
//    self.hittestView.views = @[self.ComposeBtn, self.settingBtn];
//}

# pragma mark - prepare segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"follower"]) {
        MyFollowVC *vc = segue.destinationViewController;
        NMFollowerType type = [sender integerValue] == 1?NMFollowerTypeMyFollow: NMFollowerTypeFollower;
        vc.type = type;
    }
//    if ([segue.identifier isEqualToString:@"set coin"]) {
//        SetCoinVC *vc = segue.destinationViewController;
//    }
}


# pragma mark - Click Btn

- (IBAction)clickMetroBtn:(id)sender {
    UIGestureRecognizer *gesture = sender;
    UIView *view = gesture.view;
    switch (view.tag) {
        case 3:
            [self performSegueWithIdentifier:@"Theme" sender:nil];
            break;
        case 4:
            [self performSegueWithIdentifier:@"new moment" sender:nil];
            break;
        case 5:
            [self performSegueWithIdentifier:@"set coin" sender:nil];
            break;
            
        default:
            break;
    }
}
- (IBAction)clickFollow:(id)sender {
    UIGestureRecognizer *rcg = sender;
    UIView *view = rcg.view;
    switch (view.tag) {
        case 10:
            [self performSegueWithIdentifier:@"follower" sender:@1];
            break;
        case 11:
            [self performSegueWithIdentifier:@"follower" sender:@0];
            break;
            
        default:
            break;
    }
}


@end
