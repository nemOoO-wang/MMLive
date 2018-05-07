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
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;

@end

@implementation RegistInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.girlBtn setSelected:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
