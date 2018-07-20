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


@end

@implementation RandomVCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BeeNet sharedInstance] requestWithType:Request_GET url:@"/chat/user/randomRing" param:nil success:^(id data) {
//        data[@"data"];
    } fail:^(NSString *message) {
        [SVProgressHUD showInfoWithStatus:@"没有合适的主播"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.dataArr = [@[@"gakki",@"gakki",@"gakki",@"gakki",@"gakki",
                     @"gakki",@"gakki",@"gakki",@"gakki",@"gakki",
                     @"gakki",@"gakki",@"gakki",@"gakki",@"gakki"] mutableCopy];
    [self startFire];

}

-(void)startFire{
    if (!self.fireBtnTimer) {
        self.fireBtnTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(fireButtons) userInfo:nil repeats:YES];
    }
    [self.fireBtnTimer fire];
}

-(void)fireButtons{
    if (self.dataArr.count>0) {
        NSString *name = [self.dataArr objectAtIndex:0];
        [self.dataArr removeObjectAtIndex:0];
        RVBubbleButton *particleBtn = [RVBubbleButton buttonWithType:UIButtonTypeCustom];
        [particleBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [self.emmitContainerView addSubview:particleBtn];
        [particleBtn fire];
    }else{
        [self.fireBtnTimer invalidate];
        // change view
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self startBgAni];
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
