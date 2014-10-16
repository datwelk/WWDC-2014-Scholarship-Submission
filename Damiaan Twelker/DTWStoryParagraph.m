//
//  DTWStoryParagraph.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWStoryParagraph.h"

@implementation DTWStoryParagraph

+ (instancetype)paragraphWithText:(NSString *)text
{
    return [[[self class] alloc] initWithText:text];
}

+ (instancetype)paragraphWithImage:(UIImage *)image rounded:(BOOL)rounded
{
    return [[[self class] alloc] initWithImage:image rounded:rounded];
}

- (instancetype)initWithText:(NSString *)text
{
    if (self = [super init])
    {
        _text = text;
        _type = DTWStoryParagraphTypeText;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
                      rounded:(BOOL)rounded
{
    if (self = [super init])
    {
        _image = image;
        _type = DTWStoryParagraphTypeImage;
        _imageRounded = rounded;
    }
    
    return self;
}

@end
