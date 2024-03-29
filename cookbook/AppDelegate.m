//
//  AppDelegate.m
//  cookbook
//
//  Created by silvon on 13-1-22.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ViewController.h"
@implementation AppDelegate

@synthesize audioPlayer;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    // musice
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    NSData *mp3Data = [NSData dataWithContentsOfFile:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:mp3Data error:NULL];
    self.audioPlayer.volume = 0.5;
    self.audioPlayer.numberOfLoops = NSIntegerMax;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];

    NSString *pathAlarm = [[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"];
    NSData *dataAlarm = [NSData dataWithContentsOfFile:pathAlarm];
    self.alarm = [[AVAudioPlayer alloc] initWithData:dataAlarm error:NULL];
    self.alarm.volume = 1;
    self.alarm.numberOfLoops = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]  bounds]];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];

    // 启动画面动画
    self.splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 1024, 768)];
    self.splashView.image = [UIImage imageNamed:@"Default-Landscape.png"];
    [self.window.rootViewController.view addSubview:self.splashView];
    [self.window.rootViewController.view bringSubviewToFront:self.splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    self.splashView.alpha = 0.0;
    [UIView commitAnimations];

    
    [Parse setApplicationId:@"jAyjBkPg6CV09Rl63UBkDW7Q7cZ45UcjtDkv2uZk"
                  clientKey:@"I07Vt5Y81YHJSl2KQ0KeI5DUpZ7DaJrZZYuVaRCd"];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.alarm stop];
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(application.applicationState == UIApplicationStateActive )
    {
        [self.alarm prepareToPlay];
        [self.alarm play];
        
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[NSString stringWithFormat:@"你的菜该好了，快去看看吧！"]
                                   delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        [application setApplicationIconBadgeNumber:0];// 保留
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
