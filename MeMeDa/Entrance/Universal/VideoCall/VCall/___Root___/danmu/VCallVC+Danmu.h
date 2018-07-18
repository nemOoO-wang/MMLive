//
//  VCallVC+Danmu.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "VCallVC.h"


@interface VCallVC (Danmu)<RCIMClientReceiveMessageDelegate>

-(void)enterDanmu;
-(void)quitDamnu;

@end
