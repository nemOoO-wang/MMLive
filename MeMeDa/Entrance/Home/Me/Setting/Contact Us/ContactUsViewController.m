//
//  ContactUsViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ContactUsViewController.h"
#import "NMTextView.h"


@interface ContactUsViewController ()
@property (weak, nonatomic) IBOutlet NMTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *btnView;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"FFFFFF " alpha:0.4].CGColor;
    self.textView.layer.borderWidth = 1;
    self.btnView.layer.borderColor = [UIColor colorWithHexString:@"FFFFFF " alpha:0.4].CGColor;
    self.btnView.layer.borderWidth = 1;
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

@end
