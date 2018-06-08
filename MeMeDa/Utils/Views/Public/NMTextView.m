//
//  NMTextView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMTextView.h"


IB_DESIGNABLE
@implementation NMTextView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.text = self.placeHolder;
    self.textColor = self.placeColor;
    self.delegate = self;
    if (self.noEdge) {
        self.textContainerInset = UIEdgeInsetsZero;
    }
}


// text view setting
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.placeHolder]) {
        textView.text = @"";
        textView.textColor = self.textColor; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeHolder;
        textView.textColor = self.placeColor;
    }
    if ([self.nm_delegate respondsToSelector:@selector(nm_textViewDidEndEditing:)]) {
        [_nm_delegate nm_textViewDidEndEditing:self];
    }
    [textView resignFirstResponder];
}


@end
