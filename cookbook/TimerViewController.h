//
//  TimerViewController.h
//  cookbook
//
//  Created by silvon on 13-1-29.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *customPickerView;
@property (nonatomic, strong) NSArray *hoursArray;
@property (nonatomic, strong) NSArray *minsArray;
@property (nonatomic)   NSTimeInterval interval;

@end
