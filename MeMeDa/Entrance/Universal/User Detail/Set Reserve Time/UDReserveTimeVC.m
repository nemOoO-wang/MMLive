//
//  UDReserveTimeVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/28/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UDReserveTimeVC.h"

@interface UDReserveTimeVC ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *currntCountLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation UDReserveTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // layout views
    self.cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelBtn.layer.borderWidth = 0.2;
    self.confirmBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.confirmBtn.layer.borderWidth = 0.2;
    // set slider
    NSDictionary *tmpDic = MDUserDic[@"level"];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 60;
    self.slider.value = 0;
    self.currntCountLabel.text = @"0";
}

- (IBAction)vChanged:(id)sender {
    NSInteger value = (int)self.slider.value;
    self.currntCountLabel.text = [NSString stringWithFormat:@"%ld",value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickConfirm:(id)sender {
    NSInteger value = (int)self.slider.value;
    NSDictionary *param = @{@"length":@(value), @"userId":self.usrDic[@"id"]};
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/sub/insertAppointment" andParam:param andSuccess:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"预约成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
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
