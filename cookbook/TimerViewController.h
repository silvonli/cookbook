//
//  TimerViewController.h
//  cookbook
//
//  Created by silvon on 13-1-29.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定时窗口位置
#define RECT_TIMERMODULVIEW              CGRectMake(0, 0, 372, 415)

@interface TimerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UILabel *countDownLable;
@property (nonatomic, strong) UIButton *beginButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic)   BOOL  pickModel;
@property (nonatomic, strong) NSArray *hoursArray;
@property (nonatomic, strong) NSArray *minsArray;

@end
