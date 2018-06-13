//
//  PacketVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "PacketVC.h"

@interface PacketVC ()
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@end

@implementation PacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 余额
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getSelfBlance" andParam:nil andSuccess:^(id data) {
        self.currentLabel.text = [NSString stringWithFormat:@"%ld",[data[@"data"] integerValue]];
    }];
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
