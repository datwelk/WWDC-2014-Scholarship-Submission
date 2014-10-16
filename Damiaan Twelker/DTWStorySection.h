//
//  DTWStorySection.h
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTWStorySection : NSObject

// If image is nil, section has the same image as the
// previous section.
@property (nonatomic, strong, readonly) NSArray *paragraphs;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) UIImage *image;

+ (instancetype)sectionWithTitle:(NSString *)title
                           image:(UIImage *)image
                      paragraphs:(NSArray *)paragraphs;

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                   paragraphs:(NSArray *)paragraphs;

@end
