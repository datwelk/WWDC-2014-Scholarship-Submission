//
//  DTWPortfolioViewController.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWStoryViewController.h"
#import "DTWStoryView.h"
#import "DTWStoryTeller.h"
#import "DTWButton.h"

@interface DTWStoryViewController () <DTWStoryTellerDelegate> {
    BOOL _storyTellerStartedOnce;
    DTWStoryView *_storyView;
    DTWStoryTeller *_storyTeller;
    DTWButton *_restartButton;
}

@end

@implementation DTWStoryViewController

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    [self setupSubviews];
    
    DTWStory *story = [DTWStory story];
    _storyTeller = [DTWStoryTeller storyTellerWithStory:story];
    _storyTeller.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startStoryIfNeeded];
}

#pragma mark -

- (void)setupSubviews
{
    _storyView = [DTWStoryView new];
    _storyView.frame = self.view.bounds;
    _storyView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_storyView];
    
    UIImage *image = [UIImage imageNamed:@"restart-arrow.png"];
    _restartButton = [DTWButton new];
    _restartButton.hitTestInsets = UIEdgeInsetsMake(-20.0f, -20.0f, -20.0f, -20.0f);
    [_restartButton setBackgroundImage:image
                              forState:UIControlStateNormal];
    [_restartButton addTarget:self
                       action:@selector(restartButtonClicked)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_restartButton];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    _restartButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints = nil;
    NSDictionary *views = @{@"restartButton" : _restartButton};
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[restartButton]-10-|"
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[restartButton]-10-|"
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self.view addConstraints:constraints];
}

- (void)startStoryIfNeeded
{
    if (_storyTellerStartedOnce) {
        return;
    }
    
    _storyTellerStartedOnce = YES;
    [_storyTeller start];
}

- (void)restartButtonClicked
{
    [_storyTeller start];
}

#pragma mark - DTWStoryTellerDelegate

- (void)storyTellerDidReachSection:(DTWStorySection *)section
                         paragraph:(DTWStoryParagraph *)paragraph
{
    // New section reached.
    void(^completion)() = ^{
        [_storyTeller next];
    };
    
    [_storyView replaceHeaderWithString:section.title
                             bodyString:paragraph.text
                                  image:paragraph.image
                                rounded:paragraph.imageRounded
                             background:section.image
                             completion:completion];
}

- (void)storyTellerDidReachParagraph:(DTWStoryParagraph *)paragraph
{
    // New paragraph reached inside section.
    void(^completion)() = ^{
        [_storyTeller next];
    };
    
    [_storyView replaceBodyWithString:paragraph.text
                                image:paragraph.image
                              rounded:paragraph.imageRounded
                           completion:completion];
}

- (void)storyTellerDidStop
{
    _restartButton.hidden = NO;
    _restartButton.enabled = YES;
}

- (void)storyTellerWillStart
{
    _restartButton.hidden = YES;
    _restartButton.enabled = NO;
}

@end
