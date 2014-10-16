//
//  DTWVolumeObserver.h
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 14/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTWVolumeObserver : NSObject

+ (instancetype)sharedInstance;

- (void)startObservingVolume;
- (void)stopObservingVolume;

@end
