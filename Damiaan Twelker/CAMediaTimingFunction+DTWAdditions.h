//
//  CAMediaTimingFunction+DTWAdditions.h
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAMediaTimingFunction (DTWAdditions)

+ (instancetype)dtw_easeOutQuint;
+ (instancetype)dtw_easeInSine;
+ (instancetype)dtw_easeInQuint;

@end
