//
//  DTWAppDelegate.m
//  Damiaan Twelker
//
//  Created by Damiaan Twelker on 13/04/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "DTWAppDelegate.h"
#import "DTWStoryViewController.h"
#import "DTWVolumeObserver.h"

@interface DTWAppDelegate () {
    DTWStoryViewController *_rootViewController;
}

@end

@implementation DTWAppDelegate

- (void)dealloc
{
    [[DTWVolumeObserver sharedInstance] stopObservingVolume];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.idleTimerDisabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootViewController = [DTWStoryViewController new];
    self.window.rootViewController = _rootViewController;
    
    [self.window makeKeyAndVisible];
    
    [[DTWVolumeObserver sharedInstance] startObservingVolume];
    
    return YES;
}

@end
