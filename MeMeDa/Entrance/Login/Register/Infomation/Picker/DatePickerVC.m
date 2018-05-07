//
//  DatePickerVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "DatePickerVC.h"

@interface DatePickerVC ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.oldDate) {
        self.oldDate = [[NSDate alloc] init];
    }
    [self.datePicker setDate:self.oldDate];
}

- (IBAction)clickConfirm:(id)sender {
    self.pickDate(self.datePicker.date);
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)clickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
