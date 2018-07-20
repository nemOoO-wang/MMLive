//
//  EavesdropVC+show.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "EavesdropVC+show.h"
#import "EvsCell.h"


@implementation EavesdropVC (show)

-(void)setupDanmu{
    self.currentShowTbl = 4;
    // danmu
//    self.dataArr = @[@[@"dfd",@"dfd",@"dfd",@"dfd",@"dfd"],
//                     @[@"dfd",@"dfd",@"dfd",@"dfd",@"dfd"],
//                     @[@"dfd",@"dfd",@"dfd",@"dfd",@"dfd"]];
    
//    @"/chat/user/danmu"
//    @"/chat/danmaku/all"
    
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/danmu" andParam:nil andSuccess:^(id data) {
        NSDictionary *tmpArr = data[@"data"];
//        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
//        [tmpArr addObject:tmpDic[@"tixing"]];
//        [tmpArr addObject:tmpDic[@"guli"]];
//        [tmpArr addObject:tmpDic[@"tiaoxiao"]];
        self.dataArr = [tmpArr copy];
        [self.tb1 reloadData];
        [self.tb2 reloadData];
        [self.tb3 reloadData];
    }];
}

# pragma mark - data
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EvsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSArray *tmpArr = self.dataArr[tableView.tag];
    cell.contentLabel.text = tmpArr[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *subArr = self.dataArr[tableView.tag];
    return subArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}

# pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setShowIndex:4];
}

# pragma mark - click

- (IBAction)clickShowTable:(id)sender {
    UIGestureRecognizer *gst = (UIGestureRecognizer *)sender;
    NSInteger showIndex = gst.view.tag;
    if (self.currentShowTbl == showIndex) {
        [self setShowIndex:4];
    }else{
        [self setShowIndex:showIndex];
    }
}

# pragma mark - animate
-(void)setShowIndex:(NSInteger)index{
    NSInteger show = 15;
    NSInteger hide = -190;
    self.currentShowTbl = index;
    [UIView animateWithDuration:0.3 animations:^{
        switch (index) {
            case 0:
                self.tb1ToBottom.constant = show;
                self.tb2ToBottom.constant = hide;
                self.tb3ToBottom.constant = hide;
                break;
            case 1:
                self.tb1ToBottom.constant = hide;
                self.tb2ToBottom.constant = show;
                self.tb3ToBottom.constant = hide;
                break;
            case 2:
                self.tb1ToBottom.constant = hide;
                self.tb2ToBottom.constant = hide;
                self.tb3ToBottom.constant = show;
                break;
                
            default:
                self.tb1ToBottom.constant = hide;
                self.tb2ToBottom.constant = hide;
                self.tb3ToBottom.constant = hide;
                break;
        }
        [self.view layoutIfNeeded];
    }];
}

@end
