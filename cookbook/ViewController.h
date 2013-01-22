//
//  ViewController.h
//  cookbook
//
//  Created by silvon on 13-1-22.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet GMGridView *recipeItemView;

@property (weak, nonatomic) UIButton *currentButton;
@end
