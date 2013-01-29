//
//  ViewController.h
//  cookbook
//
//  Created by silvon on 13-1-22.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) GMGridView *recipeGridView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
