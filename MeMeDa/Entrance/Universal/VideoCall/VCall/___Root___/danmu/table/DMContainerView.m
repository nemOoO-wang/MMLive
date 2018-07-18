//
//  DMContainerView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/18/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "DMContainerView.h"
#import "DMTableCell.h"
#import <RongIMLib/RongIMLib.h>
#import <Masonry.h>


@implementation DMContainerView

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (dataArr.count>0) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//        });
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
    if ([msg.content isMemberOfClass:[RCTextMessage class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        RCTextMessage *txtMsg = (RCTextMessage *)msg.content;
        cell.contentLabel.text = txtMsg.content;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"present"];
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
@end
