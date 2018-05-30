//
//  CityPickerVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "CityPickerVC.h"

@interface CityPickerVC ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSArray *provinceArr;
@property (nonatomic,strong) NSArray *cityArr;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation CityPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:nil];
    self.dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    self.provinceArr = self.dataDic[@"province"];
    self.cityArr = self.provinceArr[0][@"city"];
}

# pragma mark - <UIPickerViewDataSource>
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.provinceArr.count;
            break;
        case 1:
            return self.cityArr.count;
            break;
        default:
            return self.provinceArr.count;
            break;
    }
}

# pragma mark - <UIPickerViewDelegate>
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArr[row][@"name"];
    }else{
        return self.cityArr[row][@"name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        // province
        self.cityArr = self.provinceArr[row][@"city"];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        self.province = self.provinceArr[row][@"name"];
        self.city = self.cityArr[0][@"name"];
    }else{
        // city
        self.city = self.cityArr[row][@"name"];
    }
    
}

- (IBAction)clickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickConfirm:(id)sender {
    self.pickLocation([NSString stringWithFormat:@"%@%@",self.province,self.city]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
