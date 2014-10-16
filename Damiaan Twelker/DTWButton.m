//
//  DTWButton.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 14/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWButton.h"

@implementation DTWButton

- (UIView *)hitTest:(CGPoint)point
          withEvent:(UIEvent *)event
{
    CGFloat x = 0.0f + self.hitTestInsets.left;
    CGFloat y = 0.0f + self.hitTestInsets.top;
    CGFloat width = self.frame.size.width + fabs(self.hitTestInsets.left) + fabs(self.hitTestInsets.right);
    CGFloat height = self.frame.size.height + (2 * fabs(self.hitTestInsets.top));
    CGRect largerFrame = CGRectMake(x, y, width, height);
    
    return (CGRectContainsPoint(largerFrame, point) == YES) ? self : nil;
}

@end
