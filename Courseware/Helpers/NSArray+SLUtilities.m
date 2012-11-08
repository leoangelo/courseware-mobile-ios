//
//  NSArray+SLUtilities.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "NSArray+SLUtilities.h"

@implementation NSMutableArray (SLUtilities)

- (void)reverse
{
	NSInteger i = 0;
    NSInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:j];
        i++;
        j--;
    }
}

@end

@implementation NSArray (SLUtilities)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end