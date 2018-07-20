//
//  EavesdropVC+show.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "EavesdropVC.h"

@interface EavesdropVC (show)<UITableViewDelegate, UITableViewDataSource>

-(void)setupDanmu;
-(void)setShowIndex:(NSInteger)index;

@end
