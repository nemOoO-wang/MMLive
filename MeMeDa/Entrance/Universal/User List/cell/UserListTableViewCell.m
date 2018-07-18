//
//  UserListTableViewCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/11/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UserListTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIWindow+NMCurrent.h"
#import "StartCallVC.h"


@interface UserListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *psLabel;

@end

@implementation UserListTableViewCell

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:dataDic[@"headImg"]]];
    self.nameLabel.text = dataDic[@"nickname"];
    self.psLabel.text = dataDic[@"mark"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickVideoCall:(id)sender {
    if ([self.dataDic[@"anchorState"] integerValue] != 2) {
        [SVProgressHUD showWithStatus:@"主播未认证"];
    }else{
        StartCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"start call"];
        vc.usrDic = self.dataDic;
        UIViewController *current = [[[UIApplication sharedApplication] keyWindow] getCurrentViewController];
        [current presentViewController:vc animated:YES completion:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
