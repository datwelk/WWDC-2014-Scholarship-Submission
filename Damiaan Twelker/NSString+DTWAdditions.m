//
//  NSString+DTWAdditions.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "NSString+DTWAdditions.h"

@implementation NSString (DTWAdditions)

- (NSUInteger)dtw_wordCount
{
    __block NSUInteger wordCount = 0;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              wordCount++;
    }];
    
    return wordCount;
}

@end
