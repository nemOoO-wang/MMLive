//
//  SetCoinVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SetCoinVC.h"

@interface SetCoinVC ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *currntCountLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation SetCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // layout views
    self.cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelBtn.layer.borderWidth = 0.2;
    self.confirmBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.confirmBtn.layer.borderWidth = 0.2;
    // set slider
    NSDictionary *tmpDic = MDUserDic[@"level"];
    self.slider.minimumValue = [tmpDic[@"minPrice"] integerValue];
    self.slider.maximumValue = [tmpDic[@"maxPrice"] integerValue];
    self.slider.value = [MDUserDic[@"price"] integerValue];
    self.currntCountLabel.text = [MDUserDic[@"price"] stringValue];
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
    NSDictionary *param = @{@"price":@(value)};
    NSMutableDictionary *mDic = [MDUserDic mutableCopy];
    mDic[@"price"] = @(value);
    [[NSUserDefaults standardUserDefaults] setObject:[mDic copy] forKey:@"UserData"];
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/setUserPrice" andParam:param andSuccess:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"更改成功"];
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
