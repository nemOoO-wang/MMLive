//
//  NSMutableArray+NMReverse.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/30/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NSMutableArray+NMReverse.h"

@implementation NSMutableArray (NMReverse)

- (void)reverse {
    if ([self count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
