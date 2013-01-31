//
//  AppDelegate.m
//  cookbook
//
//  Created by silvon on 13-1-22.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // 启动画面动画
    self.splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 1024, 768)];
    self.splashView.image = [UIImage imageNamed:@"Default-Landscape.png"];
    [self.window.rootViewController.view addSubview:self.splashView];
    [self.window.rootViewController.view bringSubviewToFront:self.splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    self.splashView.alpha = 0.0;
    [UIView commitAnimations];
    
    // musice
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    NSData *mp3Data = [NSData dataWithContentsOfFile:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:mp3Data error:NULL];
    self.audioPlayer.volume = 0.5;
    self.audioPlayer.numberOfLoops = NSIntegerMax;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(application.applicationState == UIApplicationStateActive )
    {
        [[[UIAlertView alloc] initWithTitle:@"提醒"
                                    message:[NSString stringWithFormat:@"你的菜该好了，快去看看吧！"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
     
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self.splashView removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
