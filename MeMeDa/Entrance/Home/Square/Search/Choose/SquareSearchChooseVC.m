
//
//  SquareSearchChooseVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareSearchChooseVC.h"

@interface SquareSearchChooseVC ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation SquareSearchChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

# pragma mark - <UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(self.subDataArr){
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return self.dataArr.count+1;
    }else{
        if ([self.siftKey isEqualToString:@"cityName"]) {
            NSInteger section = [self.pickerView selectedRowInComponent:0];
            if (section == 0) {
                return 1;
            }
            self.subDataArr = self.dataArr[section-1][@"city"];
            return self.subDataArr.count+1;
        }
        return self.subDataArr.count+1;
    }
}

# pragma mark - <UIPickerViewDelegate>
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"不限";
    }
    if ([self.siftKey isEqualToString:@"cityName"]) {
        if(component == 0){
            return self.dataArr[row-1][@"name"];
        }else{
            NSInteger section = [self.pickerView selectedRowInComponent:0]-1;
            return self.subDataArr[row-1][@"name"];
        }
    }
    if ([self.siftKey isEqualToString:@"price"]) {
        // 选择金币改为范围
        NSInteger value = [self.dataArr[row - 1] integerValue];
        NSString *result = [NSString stringWithFormat:@"%ld ~ %ld", value, value+199];
        return result;
    }
    if(component == 1){
        return self.subDataArr[row-1];
    }
    return self.dataArr[row-1];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.subDataArr) {
        if (component == 0) {
            if (row == 0) {
                self.subDataArr = @[];
            }else{
                self.subDataArr = self.dataArr[row-1][@"city"];
                [self.pickerView reloadComponent:1];
            }
        }
    }
}

# pragma mark - Cancel
-(void)dismissThis{
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
    }];
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissThis];
}

- (IBAction)clickConfirm:(id)sender {
    if ([self.pickerView selectedRowInComponent:0] == 0) {
        [self.vc.searchDic removeObjectForKey:self.siftKey];
        UILabel *label = self.vc.labelDic[self.siftKey];
        label.text = @"不限";
    }else{
        // 特殊处理
        if ([self.siftKey isEqualToString:@"cityName"]) {
            NSString *value;
            if ([self.pickerView selectedRowInComponent:1] == 0) {
                value = self.dataArr[[self.pickerView selectedRowInComponent:0]-1][@"name"];
            }else{
                value = self.subDataArr[[self.pickerView selectedRowInComponent:1]-1][@"name"];                
            }
            UILabel *label = self.vc.labelDic[@"cityName"];
            label.text = value;
            self.vc.searchDic[self.siftKey] = value;
            [self dismissThis];
            return;
        }
        // 通用处理
        if (self.subDataArr) {
            
        }else{
            NSString *value = self.dataArr[[self.pickerView selectedRowInComponent:0]-1];
            self.vc.searchDic[self.siftKey] = value;
            UILabel *label = self.vc.labelDic[self.siftKey];
            label.text = value;
        }
    }
    [self dismissThis];
}

- (IBAction)clickCancel:(id)sender {
    [self dismissThis];
}

@end
