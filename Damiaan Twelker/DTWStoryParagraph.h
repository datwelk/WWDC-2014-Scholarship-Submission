//
//  DTWStoryParagraph.h
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DTWStoryParagraphType) {
    DTWStoryParagraphTypeText,
    DTWStoryParagraphTypeImage
};

@interface DTWStoryParagraph : NSObject

@property (nonatomic, assign, readonly) NSUInteger type;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, assign) BOOL imageRounded;

+ (instancetype)paragraphWithText:(NSString *)text;
+ (instancetype)paragraphWithImage:(UIImage *)image rounded:(BOOL)rounded;

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithImage:(UIImage *)image rounded:(BOOL)rounded;

@end
