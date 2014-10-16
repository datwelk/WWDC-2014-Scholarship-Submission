//
//  DTWContentView.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWStoryView.h"
#import "CAMediaTimingFunction+DTWAdditions.h"
#import "NSString+DTWAdditions.h"

#define HEADER_APPEAR_MOVE_ANIMATION_DURATION               1.2f
#define HEADER_DISAPPEAR_MOVE_ANIMATION_DURATION            0.1f
#define HEADER_APPEAR_FADE_ANIMATION_DURATION               0.1f

#define BODY_APPEAR_MOVE_ANIMATION_DURATION                 HEADER_APPEAR_MOVE_ANIMATION_DURATION
#define BODY_DISAPPEAR_MOVE_ANIMATION_DURATION              0.4f
#define BODY_APPEAR_FADE_ANIMATION_DURATION                 0.4f
#define BODY_DISAPPEAR_FADE_ANIMATION_DURATION              BODY_DISAPPEAR_MOVE_ANIMATION_DURATION
#define BODY_FLOAT_DISTANCE                                 20.0f
#define BODY_FLOAT_DURATION_IMAGE                           4.0f
#define BG_DISAPPEAR_FADE_ANIMATION_DURATION                BODY_DISAPPEAR_MOVE_ANIMATION_DURATION

#define BODY_MAX_IMAGE_WIDTH                                300.0f
#define BODY_MAX_IMAGE_HEIGHT                               300.0f

#define INSET_HORIZONTAL                                    20.0f
#define WORDS_READ_PER_MINUTE                               230

#define LABEL_LINE_SPACING                                  5.0f
#define BODY_LABEL_MAX_LINES                                11
#define HEADER_LABEL_MAX_LINES                              2

@interface DTWStoryView () {
    UILabel *_headerLabel;
    UIView *_bodyView;
    UIImageView *_bgImageView;
}

@end

@implementation DTWStoryView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

#pragma mark - Public

- (void)replaceBodyWithString:(NSString *)bodyString
                        image:(UIImage *)image
                      rounded:(BOOL)rounded
                   completion:(void (^)(void))completion
{
    [self replaceHeaderWithString:nil
                       bodyString:bodyString
                            image:image
                          rounded:rounded
                       background:nil
                       completion:completion];
}

- (void)replaceHeaderWithString:(NSString *)headerString
                     bodyString:(NSString *)bodyString
                          image:(UIImage *)image
                        rounded:(BOOL)rounded
                     background:(UIImage *)background
                     completion:(void (^)(void))completion
{
    // Enforce consistency
    NSCAssert(bodyString != nil || image != nil,
              @"Provide either an image or a string for the body.");
    NSCAssert((headerString != nil && bodyString != nil) ||
              (headerString == nil && bodyString != nil) ||
              (headerString != nil && image != nil) ||
              (headerString == nil && image != nil),
              @"Cannot provide new header without new body.");
    NSCAssert((headerString == nil && background == nil) ||
              (headerString != nil && background != nil) ||
              (headerString != nil && background == nil),
              @"Cannot change bg during a section.");
    
    UIView *bodyView = nil;
    
    if (image) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = image;
        imageView.frame = CGRectMake(0, 0,
                                     MIN(image.size.width, BODY_MAX_IMAGE_WIDTH),
                                     MIN(image.size.height, BODY_MAX_IMAGE_HEIGHT));
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.anchorPoint = CGPointZero;
        imageView.clipsToBounds = YES;
        
        if (rounded) {
            CGFloat size = MIN(imageView.frame.size.width, imageView.frame.size.height);
            imageView.frame = CGRectMake(0, 0, size, size);
            imageView.layer.cornerRadius = MAX(size / 2.0f, size / 2.0f);
        }
        
        bodyView = imageView;
    }
    else {
        UIFont *bodyFont = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
        bodyView = [self newLabelWithText:bodyString
                                     font:bodyFont
                         heightConstraint:(bodyFont.lineHeight + LABEL_LINE_SPACING) * BODY_LABEL_MAX_LINES];
    }
    
    [self replaceHeaderWithString:headerString
                         bodyView:bodyView
                       background:background
                       completion:completion];
}

- (void)replaceHeaderWithString:(NSString *)headerString
                       bodyView:(UIView *)bodyView
                     background:(UIImage *)background
                     completion:(void(^)(void))completion
{
    // Setup animation for both bodyViews: the new and the
    // old ones.
    CABasicAnimation *bodyHideMove = [self hideAnimationForBodyView:_bodyView];
    CABasicAnimation *bodyShowMove = [self showAnimationForBodyView:bodyView];
    CABasicAnimation *bodyHideFade =
    [self opacityAnimationFrom:1.0f
                            to:0.0f
                      duration:BODY_DISAPPEAR_FADE_ANIMATION_DURATION];
    
    CABasicAnimation *bodyShowFade =
    [self opacityAnimationFrom:0.0f
                            to:1.0f
                      duration:BODY_APPEAR_FADE_ANIMATION_DURATION];
    CABasicAnimation *bodyFloat =
    [self upwardsFloatAnimationWithBeginPosition:[bodyShowMove.toValue CGPointValue]];
    
    // Adjust float duration. If bodyView is label,
    // make duration proportional to the number of
    // words inside the label.
    if ([bodyView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)bodyView;
        NSString *bodyString = label.attributedText.string;
        bodyFloat.duration = (60.0f / WORDS_READ_PER_MINUTE) * [bodyString dtw_wordCount];
    }
    else {
        bodyFloat.duration = BODY_FLOAT_DURATION_IMAGE;
    }
    
    
    if (headerString != nil) {
        UIFont *headerFont = [UIFont fontWithName:@"HelveticaNeue" size:30.0f];
        UILabel *headerLabel = [self newLabelWithText:headerString
                                                 font:headerFont
                                     heightConstraint:(headerFont.lineHeight + LABEL_LINE_SPACING) * HEADER_LABEL_MAX_LINES];
        
        UIImageView *bgImageView = nil;
        if (background != nil) {
            bgImageView = [self newBackgroundImageViewWithImage:background];
            [self insertSubview:bgImageView atIndex:0];
        }
        
        CABasicAnimation *bgHideFade =
        [self opacityAnimationFrom:1.0f to:0.0f duration:BG_DISAPPEAR_FADE_ANIMATION_DURATION];
        
        // Define additional animations for the headers
        CABasicAnimation *headerHideMove = [self hideAnimationForHeaderLabel:_headerLabel];
        CABasicAnimation *headerShowMove = [self showAnimationForHeaderLabel:headerLabel];
        CABasicAnimation *headerShowFade =
        [self opacityAnimationFrom:0.0f
                                to:1.0f
                          duration:HEADER_APPEAR_FADE_ANIMATION_DURATION];
        
        // Put the labels in their end position already, otherwise
        // they will snap back to their current position after
        // the animation is done.
        _headerLabel.layer.position = [headerHideMove.toValue CGPointValue];
        _bodyView.layer.position = [bodyHideMove.toValue CGPointValue];
        
        if (background != nil) {
            _bgImageView.layer.opacity = [bgHideFade.toValue floatValue];
        }
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (background != nil) {
                [_bgImageView removeFromSuperview];
                _bgImageView = bgImageView;
            }
            [_headerLabel removeFromSuperview];
            [_bodyView removeFromSuperview];
            
            [self addSubview:headerLabel];
            [self addSubview:bodyView];
            
            // Put the labels in their end position already
            headerLabel.layer.position = [headerShowMove.toValue CGPointValue];
            headerLabel.layer.opacity = [headerShowFade.toValue floatValue];
            bodyView.layer.position = [bodyShowMove.toValue CGPointValue];
            bodyView.layer.opacity = [bodyShowFade.toValue floatValue];
            
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                _headerLabel = headerLabel;
                _bodyView = bodyView;
                
                // Update position
                bodyView.layer.position = [bodyFloat.toValue CGPointValue];
                
                [CATransaction begin];
                [CATransaction setCompletionBlock:completion];
                [bodyView.layer addAnimation:bodyFloat forKey:nil];
                [CATransaction commit];
            }];
            
            // After hiding the two previous labels, show
            // the new ones.
            [headerLabel.layer addAnimation:headerShowMove forKey:nil];
            [headerLabel.layer addAnimation:headerShowFade forKey:nil];
            [bodyView.layer addAnimation:bodyShowMove forKey:nil];
            [bodyView.layer addAnimation:bodyShowFade forKey:nil];
            
            [CATransaction commit];
        }];
        
        // First hide the two previous labels
        [_headerLabel.layer addAnimation:headerHideMove forKey:nil];
        [_bodyView.layer addAnimation:bodyHideMove forKey:nil];
        [_bodyView.layer addAnimation:bodyHideFade forKey:nil];
        
        if (background != nil) {
            [_bgImageView.layer addAnimation:bgHideFade forKey:nil];
        }
    
        [CATransaction commit];
    }
    else {
        // Update layer position to end value
        _bodyView.layer.position = [bodyHideMove.toValue CGPointValue];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [_bodyView removeFromSuperview];
            
            // Update layer values
            bodyView.layer.position = [bodyShowMove.toValue CGPointValue];
            bodyView.layer.opacity = [bodyShowFade.toValue floatValue];
            
            [self addSubview:bodyView];
            
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                _bodyView = bodyView;
                
                // Update position
                bodyView.layer.position = [bodyFloat.toValue CGPointValue];
                
                [CATransaction begin];
                [CATransaction setCompletionBlock:completion];
                [bodyView.layer addAnimation:bodyFloat forKey:nil];
                [CATransaction commit];
            }];
            
            [bodyView.layer addAnimation:bodyShowMove forKey:nil];
            [bodyView.layer addAnimation:bodyShowFade forKey:nil];
            
            [CATransaction commit];
        }];
        
        [_bodyView.layer addAnimation:bodyHideMove forKey:nil];
        [_bodyView.layer addAnimation:bodyHideFade forKey:nil];
        
        [CATransaction commit];
    }
}

#pragma mark - Private
#pragma mark - Animations
#pragma mark - Header label

- (CABasicAnimation *)showAnimationForHeaderLabel:(UILabel *)label
{
    CGFloat x = roundf((self.bounds.size.width - label.bounds.size.width) / 2.0f);
    
    CGPoint beginPoint = CGPointZero;
    beginPoint.x = x;
    beginPoint.y = 220.0f;
    
    CGPoint endPoint = CGPointZero;
    endPoint.x = x;
//    endPoint.y = 60.0f;
    endPoint.y = 70.0f;
    
    return [self moveAnimationFromPosition:beginPoint
                                toPosition:endPoint
                                  duration:HEADER_APPEAR_MOVE_ANIMATION_DURATION
                            timingFunction:[CAMediaTimingFunction dtw_easeOutQuint]];
}

- (CABasicAnimation *)hideAnimationForHeaderLabel:(UILabel *)label
{
    return [self hideAnimationForView:label
                             duration:HEADER_DISAPPEAR_MOVE_ANIMATION_DURATION
                       timingFunction:[CAMediaTimingFunction dtw_easeInSine]];
}

#pragma mark - Body label

- (CABasicAnimation *)upwardsFloatAnimationWithBeginPosition:(CGPoint)beginPosition
{
    CGPoint beginPoint = beginPosition;
   
    CGPoint endPoint = CGPointZero;
    endPoint.x = beginPoint.x;
    endPoint.y = beginPoint.y - BODY_FLOAT_DISTANCE;
    
    return [self moveAnimationFromPosition:beginPoint
                                toPosition:endPoint
                                  duration:0.0f
                            timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
}

- (CABasicAnimation *)showAnimationForBodyView:(UIView *)view
{
    CGFloat x = roundf((self.bounds.size.width - view.bounds.size.width) / 2.0f);
    
    CGPoint beginPoint = CGPointZero;
    beginPoint.x = x;
    beginPoint.y = self.bounds.size.height;
    
    CGPoint endPoint = CGPointZero;
    endPoint.x = x;
    endPoint.y = 170.0f;
    
    return [self moveAnimationFromPosition:beginPoint
                                toPosition:endPoint
                                  duration:BODY_APPEAR_MOVE_ANIMATION_DURATION
                            timingFunction:[CAMediaTimingFunction dtw_easeOutQuint]];
}

- (CABasicAnimation *)hideAnimationForBodyView:(UIView *)view
{
    return [self hideAnimationForView:view
                             duration:BODY_DISAPPEAR_MOVE_ANIMATION_DURATION
                       timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
}

#pragma mark - General

- (CABasicAnimation *)hideAnimationForView:(UIView *)view
                                  duration:(CGFloat)duration
                            timingFunction:(CAMediaTimingFunction *)timingFunction
{
    CGPoint beginPoint = view.layer.position;
    
    CGPoint endPoint = CGPointZero;
    endPoint.x = beginPoint.x;
    endPoint.y = -view.bounds.size.height;
    
    return [self moveAnimationFromPosition:beginPoint
                                toPosition:endPoint
                                  duration:duration
                            timingFunction:timingFunction];
}

- (CABasicAnimation *)moveAnimationFromPosition:(CGPoint)fromPosition
                                     toPosition:(CGPoint)toPosition
                                       duration:(CGFloat)duration
                                 timingFunction:(CAMediaTimingFunction *)timingFunction
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    animation.toValue = [NSValue valueWithCGPoint:toPosition];
    animation.timingFunction = timingFunction;
    animation.duration = duration;
    
    return animation;
}

- (CABasicAnimation *)opacityAnimationFrom:(CGFloat)from
                                        to:(CGFloat)to
                                  duration:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(from);
    animation.toValue = @(to);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    
    return animation;
}

#pragma mark -

- (UILabel *)newLabelWithText:(NSString *)text
                         font:(UIFont *)font
             heightConstraint:(CGFloat)maxHeight
{
    // Setup attributed string
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = LABEL_LINE_SPACING;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle,
                                 NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    NSAttributedString *string =
    [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    // Setup label
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.attributedText = string;
    label.numberOfLines = 0;
    label.layer.anchorPoint = CGPointZero;
    
    // Setup label frame
    CGSize sizeConstraint = CGSizeZero;
    sizeConstraint.width = self.bounds.size.width - (2 * INSET_HORIZONTAL);
    sizeConstraint.height = maxHeight;
    
    CGRect frame = [label.attributedText boundingRectWithSize:sizeConstraint
                                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                      context:NULL];
    frame.origin = CGPointZero;
    label.frame = frame;
    
    return label;
}

- (UIImageView *)newBackgroundImageViewWithImage:(UIImage *)image
{
    UIImageView *imageView = [UIImageView new];
    imageView.bounds = self.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.anchorPoint = CGPointZero;
    
    return imageView;
}

@end
