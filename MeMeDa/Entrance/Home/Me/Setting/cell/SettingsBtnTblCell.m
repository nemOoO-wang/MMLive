//
//  SettingsBtnTblCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SettingsBtnTblCell.h"


@interface SettingsBtnTblCell()

@property (nonatomic,weak) IBOutlet UISwitch *switchBtn;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,assign) NSInteger row;

@end


@implementation SettingsBtnTblCell

-(NSInteger)section{
    return self.tag/10;
}

-(NSInteger)row{
    return self.tag % 10;
}

-(void)initSettingArr{
    NSMutableArray *settingArr = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        settingArr[i] = @[@(YES),@(YES),@(YES)];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[settingArr copy] forKey:@"settings"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSMutableArray *settingArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"settings"];
    if (settingArr && [settingArr isKindOfClass:[NSMutableArray class]]) {
        BOOL on = [settingArr[self.section][self.row] boolValue];
        [self.switchBtn setOn:on];
    }else{
        [self initSettingArr];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)swithBtn:(id)sender {
    BOOL on = self.switchBtn.isOn;
//    [self.switchBtn setOn:on animated:YES];
    NSMutableArray *settingArr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"settings"] mutableCopy];
    if (settingArr) {
        NSMutableArray *tArr = [settingArr[self.section] mutableCopy];
        tArr[self.row] = @(on);
        settingArr[self.section] = tArr;
        [[NSUserDefaults standardUserDefaults] setObject:settingArr forKey:@"settings"];
    }
}
@end
