//
//  DTWStoryTeller.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWStoryTeller.h"

typedef NS_ENUM(NSUInteger, DTWStoryTellerState) {
    DTWStoryTellerStateIdle,
    DTWStoryTellerStateActive
};

@interface DTWStoryTeller () {
    DTWStoryTellerState _state;
    NSInteger _paragraphIdx;
    NSInteger _sectionIdx;
}

@end

@implementation DTWStoryTeller

#pragma mark - Lifecycle

+ (instancetype)storyTellerWithStory:(DTWStory *)story
{
    return [[[self class] alloc] initWithStory:story];
}

- (id)init
{
    if (self = [super init])
    {
        _state = DTWStoryTellerStateIdle;
    }
    
    return self;
}

- (instancetype)initWithStory:(DTWStory *)story
{
    if (self = [self init])
    {
        _story = story;
    }
    
    return self;
}

#pragma mark - Public

- (void)start
{
    if (_state != DTWStoryTellerStateIdle) {
        NSLog(@"Warning: start called on a story teller that "
              "is not idle. Stopping first.");
        [self stop];
    }
    
    NSCAssert(self.story != nil,
              @"Initialize the story teller with a story.");
    NSCAssert(self.story.sections.count != 0,
              @"Initialize the story teller with a story that "
              "has at least one section.");
    
    if ([self.delegate respondsToSelector:@selector(storyTellerWillStart)]) {
        [self.delegate storyTellerWillStart];
    }
    
    _state = DTWStoryTellerStateActive;
    _sectionIdx = _paragraphIdx = 0;
    
    DTWStorySection *section = self.story.sections[_sectionIdx];
    
    NSCAssert(section.paragraphs.count,
              @"Each section needs at least one paragraph.");
    
    [self.delegate storyTellerDidReachSection:section
                                    paragraph:section.paragraphs[_paragraphIdx]];
    
    // Wait for the signal that indicates the animation on the story
    // view finished.
}

- (void)stop
{
    if (_state != DTWStoryTellerStateActive) {
        NSLog(@"Warning: stop called on a story teller that"
              "is not active. Ignoring.");
        return;
    }

    _state = DTWStoryTellerStateIdle;
    _sectionIdx = _paragraphIdx = -1;
    
    if ([self.delegate respondsToSelector:@selector(storyTellerDidStop)]) {
        [self.delegate storyTellerDidStop];
    }
}

- (void)restart
{
    [self stop];
    [self start];
}

- (void)next
{
    [self advanceToNextParagraphOrSection];
}

#pragma mark - Private

- (void)advanceToNextParagraphOrSection
{
    DTWStorySection *section = self.story.sections[_sectionIdx];
    
    if (_paragraphIdx + 1 < section.paragraphs.count) {
        _paragraphIdx++;
        [self.delegate storyTellerDidReachParagraph:section.paragraphs[_paragraphIdx]];
    }
    else {
        // Last paragraph already displayed, proceed to
        // next section if possible.
        
        if (_sectionIdx + 1 < self.story.sections.count) {
            _sectionIdx++;
            _paragraphIdx = 0;
            
            DTWStorySection *section = self.story.sections[_sectionIdx];

            NSCAssert(section.paragraphs.count,
                      @"Each section needs at least one paragraph.");
            
            [self.delegate storyTellerDidReachSection:section
                                            paragraph:section.paragraphs[_paragraphIdx]];
        }
        else {
            // Everything displayed, we are done.
            [self stop];
        }
    }
}

@end
