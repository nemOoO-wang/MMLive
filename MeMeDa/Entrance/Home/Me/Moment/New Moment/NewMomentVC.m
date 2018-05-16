//
//  NewMomentVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NewMomentVC.h"

@interface NewMomentVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (weak, nonatomic) IBOutlet UIButton *vedioBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
// show constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showConstraint3;
// hide constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideConstraint3;

@end

@implementation NewMomentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // set text view
    self.textView.text = @"请输入动态文字";
    self.textView.textColor = [UIColor lightGrayColor];
    // hide btn
    self.hideConstraint1.priority = 900;
    self.showConstraint1.priority = 800;
    self.hideConstraint2.priority = 900;
    self.showConstraint2.priority = 800;
    self.hideConstraint3.priority = 900;
    self.showConstraint3.priority = 800;
    self.albumBtn.alpha = 0;
    self.vedioBtn.alpha = 0;
    self.takePhotoBtn.alpha = 0;
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

// click add animation
- (IBAction)clickAdd:(id)sender {
    UIButton *addB = sender;
    if (addB.selected) {
        addB.selected = NO;
        // hide
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:2 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.hideConstraint1.priority = 900;
            self.showConstraint1.priority = 800;
            self.hideConstraint2.priority = 900;
            self.showConstraint2.priority = 800;
            self.hideConstraint3.priority = 900;
            self.showConstraint3.priority = 800;
            self.albumBtn.alpha = 0;
            self.vedioBtn.alpha = 0;
            self.takePhotoBtn.alpha = 0;
            [self.view layoutIfNeeded];
        } completion:nil];
    }else{
        addB.selected = YES;
        // show
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
            self.hideConstraint1.priority = 800;
            self.showConstraint1.priority = 900;
            self.hideConstraint2.priority = 800;
            self.showConstraint2.priority = 900;
            self.hideConstraint3.priority = 800;
            self.showConstraint3.priority = 900;
            self.albumBtn.alpha = 1;
            self.vedioBtn.alpha = 1;
            self.takePhotoBtn.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

// text view setting
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入动态文字"]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入动态文字";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}
@end
