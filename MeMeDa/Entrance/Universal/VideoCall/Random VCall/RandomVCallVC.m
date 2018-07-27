//
//  RandomVCallVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "RandomVCallVC.h"
#import "RVBubbleButton.h"


@interface RandomVCallVC ()

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSTimer *fireBtnTimer;
@property (weak, nonatomic) IBOutlet UILabel *info1Label;
@property (weak, nonatomic) IBOutlet UILabel *info2Label;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *resetTapGesture;


@end

@implementation RandomVCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [self startBgAni];
    //    self.dataArr = [@[@"gakki",@"gakki",@"gakki",@"gakki",@"gakki",
    //                     @"gakki",@"gakki",@"gakki",@"gakki",@"gakki",
    //                     @"gakki",@"gakki",@"gakki",@"gakki",@"gakki"] mutableCopy];
//    self.dataArr = [@[MDUserDic] mutableCopy];
//    [self startFire];
    [self refreshData];
}

-(void)refreshData{
    [[BeeNet sharedInstance] requestWithType:Request_GET url:@"/chat/user/randomRing" param:nil success:^(id data) {
        self.dataArr = [data[@"data"] mutableCopy];
        self.info1Label.text = [NSString stringWithFormat:@"已为你匹配%ld个对象",self.dataArr.count];
        self.info2Label.hidden = NO;
        self.resetTapGesture.enabled = NO;
        [self startFire];
    } fail:^(NSString *message) {
        [SVProgressHUD showInfoWithStatus:@"没有合适的主播"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

-(void)startFire{
    // 预先发送4个
    [self fireButtons];
    [self fireButtons];
    [self fireButtons];
    [self fireButtons];
    
    self.fireBtnTimer = [NSTimer scheduledTimerWithTimeInterval:1.9 target:self selector:@selector(fireButtons) userInfo:nil repeats:YES];
    [self.fireBtnTimer fire];
}

-(void)fireButtons{
    if (self.dataArr.count>0) {
        RVBubbleButton *particleBtn = [RVBubbleButton buttonWithType:UIButtonTypeCustom];
        // 测试时期为图像 uri
//        NSString *name = [self.dataArr objectAtIndex:0];
//        [particleBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        // 实际为用户 dic
        NSDictionary *uDic = [self.dataArr objectAtIndex:0];
        particleBtn.userDic = uDic;
        __weak typeof(self) weakSelf = self;
        particleBtn.supVC = weakSelf;
        [self.emmitContainerView addSubview:particleBtn];
        [particleBtn fire];
        [self.dataArr removeObjectAtIndex:0];
    }else{
        [self.fireBtnTimer invalidate];
        // change view
        self.info1Label.text = @"换一组用户";
        self.info2Label.hidden = YES;
        self.resetTapGesture.enabled = YES;
    }
}


-(void)startBgAni{
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionAutoreverse| UIViewAnimationOptionRepeat| UIViewAnimationCurveEaseInOut animations:^{
        self.bgImgView.alpha = 0;
    } completion:^(BOOL finished) {
//        reset img
    }];
}

- (IBAction)clickQuit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickReset:(id)sender {
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
