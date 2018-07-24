//
//  VCSendPresentVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/24/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "VCSendPresentVC.h"


#define RowHeight 150

@interface VCSendPresentVC ()<UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation VCSendPresentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/gift/getGiftList" andParam:nil andSuccess:^(id data) {
        self.presentArr = data[@"data"];
        [self.pickerView reloadComponent:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - data
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // view
    if (!view) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"VCSPView" owner:self options:nil] firstObject];
    }
    VCSPView *spView = (VCSPView *)view;
    // settings
    NSDictionary *dic = self.presentArr[row];
    [spView.imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    spView.nameLabel.text = dic[@"name"];
    spView.priceLabel.text = [NSString stringWithFormat:@"花费：%ld",[dic[@"price"] integerValue]];
    view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, RowHeight+5);
    return spView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return RowHeight;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.presentArr.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)clickSend:(id)sender {
    BarrageMessage *msg = [[BarrageMessage alloc] init];
    // msg
    msg.senderUserInfo = [self.supVC genMeInfo];
    msg.name = MDUserDic[@"nickname"];
    msg.danmu = @"X1";
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSDictionary *dic = self.presentArr[row];
    msg.img = dic[@"img"];
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_CHATROOM targetId:self.supVC.meeting.name content:msg pushContent:nil pushData:nil success:^(long messageId) {
        [self.supVC refreshMsg];
        [self dismissViewControllerAnimated:YES completion:nil];
    } error:^(RCErrorCode nErrorCode, long messageId) {
    }];
}


- (IBAction)clickQuit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
