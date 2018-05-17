//
//  BuyCoinVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "BuyCoinVC.h"

@interface BuyCoinVC ()<UITextFieldDelegate>

@property (nonatomic,assign) NSInteger payWay; // 1:zfb    2:wepay

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV1;
@property (weak, nonatomic) IBOutlet UIImageView *imgV2;
@property (weak, nonatomic) IBOutlet UIImageView *imgV3;
@property (weak, nonatomic) IBOutlet UIImageView *imgV4;
@property (weak, nonatomic) IBOutlet UIImageView *isZfbBtn;
@property (weak, nonatomic) IBOutlet UIImageView *isWepayBtn;

@end

@implementation BuyCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"自定义金额" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self.textField setAttributedPlaceholder:attrStr];
    self.textBackView.layer.borderColor = [UIColor colorWithHexString:@"FF7799"].CGColor;
    self.payWay = 1;
}

-(void)setBackHighlight:(NSInteger)index{
    switch (index) {
        case 1:
            [self.imgV1 setImage:[UIImage imageNamed:@"pic_chongzhi_sel"]];
            [self.imgV2 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV3 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV4 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            self.textBackView.layer.borderWidth = 0;
            break;
        case 2:
            [self.imgV1 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV2 setImage:[UIImage imageNamed:@"pic_chongzhi_sel"]];
            [self.imgV3 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV4 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            self.textBackView.layer.borderWidth = 0;
            break;
        case 3:
            [self.imgV1 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV2 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV3 setImage:[UIImage imageNamed:@"pic_chongzhi_sel"]];
            [self.imgV4 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            self.textBackView.layer.borderWidth = 0;
            break;
        case 4:
            [self.imgV1 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV2 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV3 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV4 setImage:[UIImage imageNamed:@"pic_chongzhi_sel"]];
            self.textBackView.layer.borderWidth = 0;
            break;
        case 5:
            [self.imgV1 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV2 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV3 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV4 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            self.textBackView.layer.borderWidth = 4;
            break;
            
        default:
            [self.imgV1 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV2 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV3 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            [self.imgV4 setImage:[UIImage imageNamed:@"pic_chongzhi_nol"]];
            self.textBackView.layer.borderWidth = 0;
            break;
    }
}

- (IBAction)clickCoin:(id)sender {
    UIGestureRecognizer *gesture = sender;
    UIView *view = gesture.view;
    [self setBackHighlight:view.tag];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setBackHighlight:5];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.textField.text isEqualToString:@""]) {
        [self setBackHighlight:0];
    }else{
        [self setBackHighlight:5];
    }
}

- (IBAction)clickPayWay:(id)sender {
    UIGestureRecognizer *ges = sender;
    UIView *view = ges.view;
    switch (view.tag) {
        case 1:
            [self.isZfbBtn setImage:[UIImage imageNamed:@"icon_xuanzhong"]];
            [self.isWepayBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_no"]];
            break;
        case 2:
            [self.isWepayBtn setImage:[UIImage imageNamed:@"icon_xuanzhong"]];
            [self.isZfbBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_no"]];
            break;
            
        default:
            break;
    }
    self.payWay = view.tag;
}


@end
