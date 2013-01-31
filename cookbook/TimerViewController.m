//
//  TimerViewController.m
//  cookbook
//
//  Created by silvon on 13-1-29.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "TimerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define PICKER_COMPONENT_WIDTH   148.0
#define PICKER_ROW_HEIGHT        30.0
#define SUPERVIEW_CORNERRADIUS   44.0

// 按钮位置
#define RECT_BEGINBUTTON         CGRectMake(244, 202, 121, 46)
#define RECT_CANCELBUTTON        CGRectMake(83, 202, 121, 46)
// PICKER位置
#define RECT_PICKERVIEW          CGRectMake(64, 10, 320, 200)
#define RECT_PICKEMASK           CGRectMake(11, 11, 298, 320)
#define POINT_LABELHOURS         CGPointMake(120, 88)
#define POINT_LABELMINS          CGPointMake(270, 88)
@interface TimerViewController ()

@end

@implementation TimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_timer.png"]];    
    
    // 数据
    NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
    for (int i=0; i<24; i++)
    {
        NSString *str = [[NSNumber numberWithInt:i] stringValue];
        [hoursArray addObject:str];
    }
    self.hoursArray = hoursArray;
    
    NSMutableArray *minsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<61; i++)
    {
        NSString *str = [[NSNumber numberWithInt:i] stringValue];
        [minsArray addObject:str];
    }
    self.minsArray = minsArray;
    
    [self addPickerView];
    [self addPickerLabel:@"小时" position:POINT_LABELHOURS];
    [self addPickerLabel:@"分钟" position:POINT_LABELMINS];
    
    UIButton *btnBeg = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBeg.frame = RECT_BEGINBUTTON;
    [btnBeg setBackgroundImage:[UIImage imageNamed:@"btn_timerbeg.png"] forState:UIControlStateNormal];
    [btnBeg addTarget:self action:@selector(buttonBegin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBeg];
    
    UIButton *btnCanel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCanel.frame = RECT_CANCELBUTTON;
    [btnCanel setBackgroundImage:[UIImage imageNamed:@"btn_timercancel.png"] forState:UIControlStateNormal];
    [btnCanel addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCanel];

}

- (void) viewWillAppear:(BOOL)animated
{
    self.view.superview.layer.cornerRadius  = SUPERVIEW_CORNERRADIUS;
    self.view.superview.layer.masksToBounds = YES;
}

- (void) viewDidUnload
{
    [self setCustomPickerView:nil];
    [super viewDidUnload];
}

- (void)buttonBegin:(id)sender
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    NSDate *pickerDate = [[NSDate alloc] initWithTimeIntervalSinceNow:self.interval];
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.fireDate = pickerDate;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.alertBody = @"你的菜该好了，快去看看吧！";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonCancel:(id)sender
{
    self.interval = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addPickerView
{
    self.customPickerView = [[UIPickerView alloc] initWithFrame:RECT_PICKERVIEW];
    self.customPickerView.dataSource = self;
	self.customPickerView.delegate = self;
	self.customPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.customPickerView];
    
    CALayer* mask = [[CALayer alloc] init];
    [mask setBackgroundColor: [UIColor blackColor].CGColor];
    [mask setFrame: RECT_PICKEMASK];
    [mask setCornerRadius: 5.0f];
    [self.customPickerView.layer setMask: mask];
    
    NSArray *notifArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
   
    if (notifArr.count == 1)
    {
        UILocalNotification *notif = notifArr[0];
        NSTimeInterval interval = [notif.fireDate timeIntervalSinceNow];
        if (interval > 0)
        {
            int nHours = floor(interval/3600);
            int nMins  = (int)round((interval - nHours*3600)/60);
            
            [self.customPickerView selectRow:nHours inComponent:0 animated:YES];
            [self.customPickerView selectRow:nMins inComponent:1 animated:YES];
            self.interval = interval;
        }
    }
    
}

- (void)addPickerLabel:(NSString *)labelString position:(CGPoint)pos
{
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
    CGFloat width = [labelString sizeWithFont:font].width;
    CGFloat height= [labelString sizeWithFont:font].height;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pos.x, pos.y, width, height)];
    label.text = labelString;
    label.font = font;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor  = [UIColor colorWithWhite:0.0f alpha:0.7f];
    label.shadowOffset = CGSizeMake(0.f, 1.0f);
    [self.view addSubview:label];

}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        return [self.hoursArray count];
    }
    else 
    {
        return [self.minsArray count];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}


#pragma mark -
#pragma mark UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return PICKER_COMPONENT_WIDTH;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return PICKER_ROW_HEIGHT;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    if (component == 0)
    {
        returnStr = [self.hoursArray objectAtIndex:row];
    }
    else if (component == 1)
    {
        returnStr = [self.minsArray objectAtIndex:row];
    }
	return returnStr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *hoursStr = [self.hoursArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString *minsStr = [self.minsArray objectAtIndex:[pickerView selectedRowInComponent:1]];
    int hoursInt = [hoursStr intValue];
    int minsInt = [minsStr intValue];
    self.interval = (hoursInt*3600) + (minsInt*60);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
                          
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
