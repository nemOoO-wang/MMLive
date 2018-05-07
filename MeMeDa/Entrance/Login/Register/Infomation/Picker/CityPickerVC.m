//
//  CityPickerVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "CityPickerVC.h"

@interface CityPickerVC ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,assign) NSInteger lastGroup;
@property (nonatomic,assign) NSInteger lastIndex;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation CityPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init lastGroup、index here!
    
    if (self.lastGroup >= 0) {
        [self.pickerView selectRow:self.lastGroup inComponent:0 animated:NO];
        [self.pickerView selectRow:self.lastIndex inComponent:1 animated:NO];
    }else{
        self.lastGroup = 0;
        self.lastIndex = 0;
    }
}

# pragma mark - <UIPickerViewDataSource>
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

# pragma mark - <UIPickerViewDelegate>
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"test";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0 && row != self.lastGroup) {
        // proviince
        self.lastGroup = row;
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (component == 1) {
        // city
        self.lastIndex = row;
    }
}


- (IBAction)clickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
