//
//  VCSendPresentVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/24/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarrageMessage.h"
#import "VCSPView.h"
#import "VCallVC.h"
#import "VCallVC+Danmu.h"

@interface VCSendPresentVC : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,strong) NSArray *presentArr;
@property (nonatomic,weak) VCallVC *supVC;

@end
