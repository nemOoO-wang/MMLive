//
//  DMContainerView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/18/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "DMContainerView.h"
#import "DMTableCell.h"
#import "BarrageMessage.h"
#import <RongIMLib/RongIMLib.h>
#import <Masonry.h>


@implementation DMContainerView

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (dataArr.count>0) {
        dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    }
}

- (void)drawRect:(CGRect)rect {
    self.dataArr = @[];
    // Drawing table
    self.tableView = [[UITableView alloc] init];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
    }];
    // regist nib
    [self.tableView registerNib:[UINib nibWithNibName:@"DMTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DMPresentTableCell" bundle:nil] forCellReuseIdentifier:@"present"];
}


# pragma mark - data
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMTableCell *cell;
    RCMessage *msg = self.dataArr[self.dataArr.count - indexPath.row - 1];
//    if ([msg.content isMemberOfClass:[RCTextMessage class]]) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        RCTextMessage *txtMsg = (RCTextMessage *)msg.content;
//        cell.contentLabel.text = txtMsg.content;
//    }else{
//        BarrageMessage *presentMsg = (BarrageMessage *)msg.content;
//        cell = [tableView dequeueReusableCellWithIdentifier:@"present"];
//    }
    BarrageMessage *bMsg = (BarrageMessage *)msg.content;
    if (![bMsg.img isEqualToString:@""] || !bMsg.img) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"present"];
        [cell.presentImgView sd_setImageWithURL:[NSURL URLWithString:bMsg.img]];
        cell.contentLabel.text = bMsg.name;
        cell.countLabel.text = bMsg.danmu;
        cell.countShadowLabel.text = bMsg.danmu;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@: %@",bMsg.name, bMsg.danmu];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
@end
