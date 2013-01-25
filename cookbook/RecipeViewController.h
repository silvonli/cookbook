//
//  RecipeViewController.h
//  cookbook
//
//  Created by silvon on 13-1-24.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) NSString *name;
@end
