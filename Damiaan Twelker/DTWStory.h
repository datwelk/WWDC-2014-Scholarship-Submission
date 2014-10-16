//
//  DTWStory.h
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTWStorySection.h"
#import "DTWStoryParagraph.h"

@interface DTWStory : NSObject

@property (nonatomic, strong, readonly) NSArray *sections;

+ (instancetype)story;

@end
