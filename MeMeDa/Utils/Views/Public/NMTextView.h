//
//  NMTextView.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMTextView : UITextView<UITextViewDelegate>

@property (nonatomic, strong) IBInspectable NSString *placeHolder;
@property (nonatomic,strong) IBInspectable UIColor *placeColor;
@property (nonatomic,strong) IBInspectable UIColor *textColor;
@property (nonatomic,assign) IBInspectable BOOL noEdge;


@end
