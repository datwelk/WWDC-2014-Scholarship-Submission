//
//  DTWVolumeObserver.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 14/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWVolumeObserver.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DTWAppDelegate.h"

typedef NS_ENUM(NSUInteger, DTWAnimationSpeed) {
    DTWAnimationSpeedSlowest,
    DTWAnimationSpeedSlow,
    DTWAnimationSpeedDefault,
    DTWAnimationSpeedFast,
    DTWAnimationSpeedFastest
};

@interface DTWVolumeObserver () {
    BOOL _observing;
    MPVolumeView *_volumeView;
    DTWAnimationSpeed _animationSpeed;
}

@end

@implementation DTWVolumeObserver

#pragma mark - Lifecycle

+ (instancetype)sharedInstance
{
    static DTWVolumeObserver *observer = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        observer = [[DTWVolumeObserver alloc] init];
    });
    
    return observer;
}

- (id)init
{
    if (self = [super init])
    {
        _animationSpeed = DTWAnimationSpeedDefault;
    }
    
    return self;
}

#pragma mark - Private

- (UIWindow *)applicationWindow
{
    DTWAppDelegate *appDelegate = (DTWAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.window;
}

- (void)addVolumeView
{
    // Add an MPVolumeView below all other views on
    // the application's only window. This prevents the
    // system's volume view from popping up.
    
    UIWindow *window = [self applicationWindow];
    _volumeView = [MPVolumeView new];
    _volumeView.userInteractionEnabled = NO;
    [window insertSubview:_volumeView atIndex:0];
}

- (void)removeVolumeView
{
    [_volumeView removeFromSuperview];
    _volumeView = nil;
}

- (void)adjustAnimationSpeedToVolumeChange:(CGFloat)oldValue :(CGFloat)newValue
{
    if (oldValue < newValue) {
        // Increase animation speed if possible
        if (_animationSpeed != DTWAnimationSpeedFastest) {
            _animationSpeed++;
        }
    }
    else {
        // Decrease animation speed if possible
        if (_animationSpeed != DTWAnimationSpeedSlowest) {
            _animationSpeed--;
        }
    }
    
    NSLog(@"Switched to animation speed: %@", [self stringFromAnimationSpeed:_animationSpeed]);
    
    UIWindow *window = [self applicationWindow];
    window.layer.speed = [self layerSpeedFromAnimationSpeed:_animationSpeed];
}

- (CGFloat)layerSpeedFromAnimationSpeed:(DTWAnimationSpeed)animationSpeed
{
    CGFloat speed = 1;
    
    switch (animationSpeed) {
        case DTWAnimationSpeedDefault:
            speed = 1.0f;
            break;
        case DTWAnimationSpeedSlow:
            speed = 0.5f;
            break;
        case DTWAnimationSpeedFast:
            speed = 2.0f;
            break;
        case DTWAnimationSpeedSlowest:
            speed = 0.25f;
            break;
        case DTWAnimationSpeedFastest:
            speed = 4.0f;
            break;
        default:
            break;
    }
    
    return speed;
}

- (NSString *)stringFromAnimationSpeed:(DTWAnimationSpeed)animationSpeed
{
    NSString *string;
    
    switch (animationSpeed) {
        case DTWAnimationSpeedDefault:
            string = @"default";
            break;
        case DTWAnimationSpeedFast:
            string = @"fast";
            break;
        case DTWAnimationSpeedSlow:
            string = @"slow";
            break;
        case DTWAnimationSpeedFastest:
            string = @"fastest";
            break;
        case DTWAnimationSpeedSlowest:
            string = @"slowest";
            break;
        default:
            break;
    }
    
    return string;
}

#pragma mark - KVO

- (void)startObservingVolume
{
    if (_observing) {
        return;
    }
    
    _observing = YES;
    [self addVolumeView];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] addObserver:self
                                      forKeyPath:@"outputVolume"
                                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                         context:NULL];
}

- (void)stopObservingVolume
{
    if (!_observing) {
        return;
    }
    
    _observing = NO;
    [self removeVolumeView];
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[AVAudioSession sharedInstance] removeObserver:[DTWVolumeObserver sharedInstance]
                                         forKeyPath:@"outputVolume"
                                            context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (![keyPath isEqualToString:@"outputVolume"]) {
        return;
    }
    
    CGFloat oldValue = [change[NSKeyValueChangeOldKey] floatValue];
    CGFloat newValue = [change[NSKeyValueChangeNewKey] floatValue];
    
    [self adjustAnimationSpeedToVolumeChange:oldValue :newValue];
}

@end
