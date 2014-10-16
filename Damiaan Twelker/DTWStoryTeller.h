//
//  DTWStoryTeller.h
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTWStory.h"

#pragma mark - DTWStoryTellerDelegate

@protocol DTWStoryTellerDelegate <NSObject>

// Called when a new paragraph is reached within the current
// section.
- (void)storyTellerDidReachParagraph:(DTWStoryParagraph *)paragraph;

// Called when new section is reached. If the section has at least
// one paragraph, the paragraph argument will hold the first
// paragraph of the section. If the section does not have any
// paragraphs, the paragraph argument will be nil.
- (void)storyTellerDidReachSection:(DTWStorySection *)section
                         paragraph:(DTWStoryParagraph *)paragraph;

@optional
- (void)storyTellerWillStart;
- (void)storyTellerDidStop;

@end

#pragma mark - DTWStoryTeller

@interface DTWStoryTeller : NSObject

@property (nonatomic, strong, readonly) DTWStory *story;
@property (nonatomic, weak) id <DTWStoryTellerDelegate> delegate;

+ (instancetype)storyTellerWithStory:(DTWStory *)story;
- (instancetype)initWithStory:(DTWStory *)story;

- (void)start;
- (void)restart;
- (void)stop;

// Call this method when the transition between
// paragraphs or sections has finished
- (void)next;

@end
