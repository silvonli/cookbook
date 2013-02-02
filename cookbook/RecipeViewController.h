//
//  RecipeViewController.h
//  cookbook
//
//  Created by silvon on 13-1-24.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSString *name;
@end
