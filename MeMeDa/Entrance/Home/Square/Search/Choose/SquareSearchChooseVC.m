
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
        return self.dataArr.count;
    }else{
        return self.subDataArr.count;
    }
}

# pragma mark - <UIPickerViewDelegate>
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 1){
        return @"!";
    }
    return self.dataArr[row];
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

- (IBAction)clickCancel:(id)sender {
    [self dismissThis];
}

@end
