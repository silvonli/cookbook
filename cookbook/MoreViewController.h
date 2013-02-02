//
//  MoreViewController.h
//  cookbook
//
//  Created by silvon on 13-1-31.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface MoreViewController : UIViewController<GMGridViewDataSource, GMGridViewActionDelegate >
@property (strong, nonatomic) GMGridView *appGridView;
@end
