//
//  DTWContentView.h
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTWStoryView : UIView

// Provide either an image or a bodyString
- (void)replaceBodyWithString:(NSString *)bodyString
                        image:(UIImage *)image
                      rounded:(BOOL)rounded
                   completion:(void(^)(void))completion;

// Provide either an image or a bodyString
- (void)replaceHeaderWithString:(NSString *)headerString
                     bodyString:(NSString *)bodyString
                          image:(UIImage *)image
                        rounded:(BOOL)rounded
                     background:(UIImage *)background
                     completion:(void(^)(void))completion;

@end
