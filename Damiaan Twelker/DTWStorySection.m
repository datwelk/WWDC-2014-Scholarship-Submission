//
//  DTWStorySection.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWStorySection.h"

@implementation DTWStorySection

+ (instancetype)sectionWithTitle:(NSString *)title
                           image:(UIImage *)image
                      paragraphs:(NSArray *)paragraphs
{
    return [[[self class] alloc] initWithTitle:title
                                         image:image
                                    paragraphs:paragraphs];
}

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                   paragraphs:(NSArray *)paragraphs
{
    if (self = [super init])
    {
        _title = title;
        _paragraphs = paragraphs;
        _image = image;
    }
    
    return self;
}

@end
