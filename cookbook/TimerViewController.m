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

#define NAV_HEIGHT              54
#define CLOSEBUTTON_FRAME       CGRectMake(0, 0, 37,  37)

//#define RECT_TIMERMODULVIEW              CGRectMake(0, 0, 372, 415)

// 按钮位置
#define BUTTON_FRAME             CGRectMake(126,272, 121, 46)
// PICKER位置
#define PICKER_FRAME             CGRectMake(26, 30, 320, 280)
#define PICKER_MASK              CGRectMake(10, 11, 300, 320)
#define PICKER_LABELHOURS_FRAME  CGRectMake(70, 100, 100, 20 )
#define PICKER_LABELMINS_FRAME   CGRectMake(220,100, 100, 20 )

#define COUNTDOWN_FRAME          PICKER_FRAME

#define LOCALNOTIFY_NAME_KEY     @"IamKey"
#define LOCALNOTIFY_NAME_VALUE   @"itIsOK"

@interface TimerViewController ()

@end

@implementation UINavigationBar (customNav)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = CGSizeMake(self.frame.size.width, NAV_HEIGHT);
    return newSize;
}

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
    
    // 导航
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_timerNav.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 关闭按钮
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CLOSEBUTTON_FRAME];
    [btnClose setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseTap) forControlEvents:UIControlEventTouchUpInside];
    btnClose.contentEdgeInsets = UIEdgeInsetsMake(-10, -6, 0, 0);
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    // 数据
    NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
    for (int i=0; i<24; i++)
    {
        NSString *str = [NSString  stringWithFormat:@"%02d",i];
        [hoursArray addObject:str];
    }
    self.hoursArray = hoursArray;
    
    NSMutableArray *minsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<61; i++)
    {
        NSString *str = [NSString  stringWithFormat:@"%02d",i];
        [minsArray addObject:str];
    }
    self.minsArray = minsArray;
    
    self.pickModel = [self itIsOKNotifications]==nil;
    
    [self addPickerView];
    [self addCountDownLabel];
    
    self.beginButton        = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginButton.frame  = BUTTON_FRAME;
    [self.beginButton setBackgroundImage:[UIImage imageNamed:@"btn_timerbeg.png"] forState:UIControlStateNormal];
    [self.beginButton addTarget:self action:@selector(btnBeginTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beginButton];
    
    self.cancelButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = BUTTON_FRAME;
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_timercancel.png"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(btnCancelTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    [self refreshDisplay];

}

- (void) refreshDisplay
{
    if (self.pickModel)
    {
        self.pickerView.hidden          = NO;
        self.countDownLable.hidden      = YES;
        self.beginButton.hidden         = NO;
        self.cancelButton.hidden        = YES;
        [self.timer invalidate];
    }
    else
    {
        self.pickerView.hidden          = YES;
        self.countDownLable.hidden      = NO;
        self.beginButton.hidden         = YES;
        self.cancelButton.hidden        = NO;
        // 更新UILabel定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}

- (void)btnCloseTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateCountDown:(id)sender
{
    UILocalNotification *notif = [self itIsOKNotifications];
    if (notif == nil)
    {
        return;
    }
    
    int interval = (int)[notif.fireDate timeIntervalSinceNow];
    if (interval >= 0)
    {
        int nHours = floor(interval/3600);
        int nMins  = (interval%3600)/60;
        int nSecs  = (interval%3600)%60;
        self.countDownLable.text = [NSString stringWithFormat:@"%02d:%02d:%02d",nHours, nMins, nSecs];
    }
    if (interval == 0)
    {
        self.pickModel = YES;
        [self refreshDisplay];
    }
}

- (void)addCountDownLabel
{
    self.countDownLable                 = [[UILabel alloc] initWithFrame:COUNTDOWN_FRAME];
    self.countDownLable.text            = @"00:00:00";
    self.countDownLable.font            = [UIFont systemFontOfSize:48];
    self.countDownLable.textAlignment   = UITextAlignmentCenter;
    self.countDownLable.textColor       = [UIColor whiteColor];
    self.countDownLable.backgroundColor = [UIColor clearColor];
    self.countDownLable.shadowColor     = [UIColor colorWithWhite:0.0f alpha:0.7f];
    self.countDownLable.shadowOffset    = CGSizeMake(0.f, 1.0f);
    [self.view addSubview:self.countDownLable];
}

- (void)addPickerView
{
    self.pickerView = [[UIPickerView alloc] initWithFrame:PICKER_FRAME];
    self.pickerView.dataSource              = self;
	self.pickerView.delegate                = self;
	self.pickerView.showsSelectionIndicator = YES;
    [self.pickerView selectRow:15 inComponent:1 animated:NO];
    [self.view addSubview:self.pickerView];
    
    CALayer* mask = [[CALayer alloc] init];
    [mask setBackgroundColor: [UIColor blackColor].CGColor];
    [mask setFrame: PICKER_MASK];
    [mask setCornerRadius: 6.0f];
    [self.pickerView.layer setMask: mask];
    
    UIFont *font  = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    UILabel *label          = [[UILabel alloc] initWithFrame:PICKER_LABELHOURS_FRAME];
    label.text              = @"小时";
    label.font              = font;
    label.textColor         = [UIColor darkGrayColor];
    label.backgroundColor   = [UIColor clearColor];
    [self.pickerView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:PICKER_LABELMINS_FRAME];
    label2.text             = @"分钟";
    label2.font             = font;
    label2.textColor        = [UIColor darkGrayColor];
    label2.backgroundColor  = [UIColor clearColor];
    [self.pickerView addSubview:label2];
    
}

- (void)btnBeginTap:(id)sender
{
    self.pickModel = ![self scheduleNotify];
    [self refreshDisplay];
}

- (void)btnCancelTap:(id)sender
{
    self.pickModel = [self cancelNotify];
    [self refreshDisplay];
}

- (UILocalNotification*) itIsOKNotifications
{
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        NSDictionary *userInfo = notification.userInfo;
        if ([LOCALNOTIFY_NAME_VALUE isEqualToString:[userInfo objectForKey:LOCALNOTIFY_NAME_KEY]])
        {
            return notification;
        }
    }
    return nil;
}

- (BOOL) scheduleNotify
{
    [self cancelNotify];
    NSString *hoursStr = [self.hoursArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    NSString *minsStr  = [self.minsArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    int interval = [hoursStr intValue]*3600 + [minsStr intValue]*60;
    
    if (interval<=0)
    {
        return NO;
    }
    
    NSDate *pickerDate = [[NSDate alloc] initWithTimeIntervalSinceNow:interval];
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.fireDate  = pickerDate;
    notif.timeZone  = [NSTimeZone defaultTimeZone];
    notif.alertBody = @"你的菜该好了，快去看看吧！";
    notif.soundName = @"alarm.mp3";
    notif.applicationIconBadgeNumber = 0;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:LOCALNOTIFY_NAME_VALUE forKey:LOCALNOTIFY_NAME_KEY];
    notif.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    return YES;
}

- (BOOL) cancelNotify
{
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        NSDictionary *userInfo = notification.userInfo;
        if ([LOCALNOTIFY_NAME_VALUE isEqualToString:[userInfo objectForKey:LOCALNOTIFY_NAME_KEY]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            return YES;
        }
    }
    return YES;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void) viewDidUnload
{
    [self setPickerView:nil];
    [self setCountDownLable:nil];
    [self setBeginButton:nil];
    [self setCancelButton:nil];
    [self setTimer:nil];
    [self setHoursArray:nil];
    [self setMinsArray:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
