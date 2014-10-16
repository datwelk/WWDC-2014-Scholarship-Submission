//
//  CAMediaTimingFunction+DTWAdditions.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "CAMediaTimingFunction+DTWAdditions.h"

@implementation CAMediaTimingFunction (DTWAdditions)

+ (instancetype)dtw_easeOutQuint
{
    return [CAMediaTimingFunction functionWithControlPoints:0.23 :1.0f :0.320 :1.0f];
}

+ (instancetype)dtw_easeInSine
{
    return [CAMediaTimingFunction functionWithControlPoints:0.47 :0.0 :0.745 :0.715];
}

+ (instancetype)dtw_easeInQuint
{
    return [CAMediaTimingFunction functionWithControlPoints:0.755 :0.050 :0.855 :0.060];
}

@end
