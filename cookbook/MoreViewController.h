//
//  MoreViewController.h
//  cookbook
//
//  Created by silvon on 13-1-31.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

// 更多
#define RECT_MOREMODULVIEW   CGRectMake(0, 0, 572, 372)


@interface MoreViewController : UIViewController<GMGridViewDataSource, GMGridViewActionDelegate >
@property (strong, nonatomic) GMGridView *appGridView;
@end
