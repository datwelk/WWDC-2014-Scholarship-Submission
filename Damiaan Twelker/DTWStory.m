//
//  DTWStory.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWStory.h"
#import "UIImage+ImageEffects.h"

@implementation DTWStory

+ (instancetype)story
{
    return [[[self class] alloc] init];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _sections =
        @[
          [DTWStorySection sectionWithTitle:@"Lorem ipsum"
                                      image:[[UIImage imageNamed:@"bg2.png"] applyDarkEffect]
                                 paragraphs:@[[DTWStoryParagraph paragraphWithText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla in arcu ac libero euismod rutrum. Pellentesque non ultricies magna. Cras in aliquam leo, in malesuada tellus."]
                                              ]],
          [DTWStorySection sectionWithTitle:@"Donec vitae"
                                      image:[[UIImage imageNamed:@"bg1.png"] applyDarkEffect]
                                 paragraphs:@[[DTWStoryParagraph paragraphWithText:@"Proin rhoncus eu enim id commodo. Quisque venenatis purus sit amet arcu semper pulvinar. Phasellus quis iaculis diam."],
                                              [DTWStoryParagraph paragraphWithText:@"Nullam tincidunt euismod quam non sollicitudin. Sed eros libero, auctor sit amet consectetur sollicitudin, ultricies et lectus."]]],
          [DTWStorySection sectionWithTitle:@"Efficitur nunc"
                                      image:[[UIImage imageNamed:@"bg3.png"] applyDarkEffect]
                                 paragraphs:@[[DTWStoryParagraph paragraphWithText:@"Etiam varius faucibus erat, ac rhoncus risus dapibus accumsan. Cras condimentum porta imperdiet. Vestibulum consequat risus in elit convallis, tristique gravida erat tempus."],
                                              [DTWStoryParagraph paragraphWithText:@"Proin nec orci ultricies, eleifend massa vel, elementum ex. Sed pulvinar risus pretium odio lobortis rutrum. Sed feugiat accumsan aliquet. Quisque tincidunt ullamcorper velit ultricies cursus."]]]];
    }
    
    return self;
}

@end
