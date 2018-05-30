//
//  RegistInfoVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/7/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "RegistInfoVC.h"
#import "DatePickerVC.h"
#import "CityPickerVC.h"

@interface RegistInfoVC ()
@property (weak, nonatomic) IBOutlet NMRegTextField *nickNameTextFIeld;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;


@end

@implementation RegistInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.boyBtn setSelected:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"date"]) {
        // date
        DatePickerVC *vc = [segue destinationViewController];
        NSDateFormatter *fm = [[NSDateFormatter alloc] init];
        fm.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [fm dateFromString:self.dateLabel.text];
        vc.oldDate = date;
        vc.pickDate = ^(NSDate *date) {
            self.dateLabel.text = [fm stringFromDate:date];
        };
    }else if ([segue.identifier isEqualToString:@"location"]) {
        // location
        CityPickerVC *vc = [segue destinationViewController];
        vc.pickLocation = ^(NSString *location) {
            self.locationLabel.text = location;
        };
    }
}

- (IBAction)clickGender:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 0) {
        [self.girlBtn setSelected:YES];
        [self.boyBtn setSelected:NO];
    }else{
        [self.girlBtn setSelected:NO];
        [self.boyBtn setSelected:YES];
    }
}
- (IBAction)clickSubmitBtn:(id)sender {
    NSMutableDictionary *mParamDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"regParam"] mutableCopy];
    mParamDic[@"nickname"] = self.nickNameTextFIeld.text;
    mParamDic[@"birthday"] = [NSString stringWithFormat:@"%@ 00:00:00",self.dateLabel.text];
    mParamDic[@"cityName"] = self.locationLabel.text;
    mParamDic[@"gender"] = self.boyBtn.selected? @"1" : @"2";
    
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/telRegister" andParam:mParamDic andHeader:nil andSuccess:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        if (self.boyBtn.selected) {
            // 成功才返回
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self performSegueWithIdentifier:@"girlon" sender:nil];
        }
    } andFailed:^(NSString *str) {
        NSLog(@"%@",str);
    }];
    
}

@end
