//
//  RecipeViewController.m
//  cookbook
//
//  Created by silvon on 13-1-24.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "RecipeViewController.h"
#import "CBDataManager.h"
#import "OHAttributedLabel/OHAttributedLabel.h"
#import "AppDelegate.h"
#import "TimerViewController.h"

#define EDGE_SPACING        40
#define SEC_SPACING         18
#define INEDGE_SPACING      20
#define BUTTON_SPACING      200

#define HK_FRAME            CGRectMake(618, 40, 366, 176)
#define NAME_FRAME          CGRectMake(40,  40, 500, 50)

@interface RecipeViewController ()

@end

@implementation RecipeViewController

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
    
    UIImage *image = [UIImage imageNamed:@"菜谱_背景.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // 按钮
    UIButton *btnRet = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRet.frame = CGRectMake(900.f, 704.0f, 100, 40);
    [btnRet setBackgroundImage:[UIImage imageNamed:@"菜谱_返回.png"] forState:UIControlStateNormal];
    [btnRet addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRet];
    
    UIButton *btnTimer = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTimer.frame = CGRectMake(901.f, 573.0f, 68, 111);
    [btnTimer setBackgroundImage:[UIImage imageNamed:@"btn_timer.png"] forState:UIControlStateNormal];
    [btnTimer addTarget:self action:@selector(buttonTimer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTimer];
    
    UIButton *btnMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMusic.frame = CGRectMake(874.f, 445.0f, 122, 108);
    [btnMusic setBackgroundImage:[UIImage imageNamed:@"btn_coffee.png"] forState:UIControlStateNormal];
    [btnMusic setBackgroundImage:[UIImage imageNamed:@"btn_coffeeplay.png"] forState:UIControlStateSelected];
    [btnMusic addTarget:self action:@selector(buttonMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnMusic];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    btnMusic.selected = !appDelegate.audioPlayer.playing;
    
    // 滚动视
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:self.scrollView];
    
        
    // 图片
    UIImageView *hk = [[UIImageView alloc] initWithFrame:HK_FRAME];
    hk.autoresizingMask = UIViewAutoresizingNone;
    hk.contentMode = UIViewContentModeCenter;
    hk.image = [UIImage imageNamed:@"菜谱_画框.png"];
    [self.scrollView addSubview:hk];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectInset(HK_FRAME, 8, 8)];
    pic.autoresizingMask = UIViewAutoresizingNone;
    pic.contentMode = UIViewContentModeCenter;
    pic.image = [UIImage imageNamed: [dataManager getRecipePicture:self.name]];    
    [self.scrollView addSubview:pic];
    
    // 创建名字
    OHAttributedLabel *labelName = [[OHAttributedLabel alloc] initWithFrame:NAME_FRAME];
    labelName.attributedText = [dataManager getNameAttStr:self.name];
    labelName.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:labelName];
    
    CGRect hkRect    = hk.frame;
    CGRect nameRect  = labelName.frame;
    CGFloat widthFull  = 1024 - EDGE_SPACING - EDGE_SPACING - BUTTON_SPACING;
    CGFloat widthNOPic = hkRect.origin.x - INEDGE_SPACING - nameRect.origin.x;
    
    CGRect  baseRect;
    CGFloat baseY;
    CGFloat maxWidth;
    NSAttributedString* attText;
    CGPoint ptOrigin;
    // 主料
    baseRect = nameRect;
    baseY    = baseRect.origin.y + baseRect.size.height + SEC_SPACING;
    attText  = [dataManager getIngredientsAttStr:self.name];
    ptOrigin = CGPointMake(baseRect.origin.x, baseY);
    maxWidth = widthNOPic;
    OHAttributedLabel* labIngredients = [self createLableWithAttributeString:attText origin:ptOrigin width:maxWidth];
    [self.scrollView addSubview:labIngredients];
    
    // 调料
    baseRect = labIngredients.frame;
    baseY    = baseRect.origin.y + baseRect.size.height + SEC_SPACING;
    attText  = [dataManager getSeasoningAttStr:self.name];
    ptOrigin = CGPointMake(baseRect.origin.x, baseY);
    maxWidth = baseRect.origin.y + baseRect.size.height<hkRect.origin.y + hkRect.size.height ? widthNOPic : widthFull;
    OHAttributedLabel* labSeasoning = [self createLableWithAttributeString:attText origin:ptOrigin width:maxWidth];
    [self.scrollView addSubview:labSeasoning];
    
    // 操作
    baseRect = labSeasoning.frame;
    baseY    = MAX(baseRect.origin.y + baseRect.size.height + SEC_SPACING, hkRect.origin.y + hkRect.size.height);
    attText  = [dataManager getOprationAttStr:self.name];
    ptOrigin = CGPointMake(baseRect.origin.x, baseY);
    maxWidth = widthFull;
    OHAttributedLabel* labOpration = [self createLableWithAttributeString:attText origin:ptOrigin width:maxWidth];
    [self.scrollView addSubview:labOpration];
    
    // 贴士
    baseRect = labOpration.frame;
    baseY    = MAX(baseRect.origin.y + baseRect.size.height + SEC_SPACING, hkRect.origin.y + hkRect.size.height);
    attText  = [dataManager getTipsAttStr:self.name];
    ptOrigin = CGPointMake(baseRect.origin.x, baseY);
    maxWidth = widthFull;
    OHAttributedLabel* labTips = [self createLableWithAttributeString:attText origin:ptOrigin width:maxWidth];
    [self.scrollView addSubview:labTips];
    

    CGFloat height = labTips.frame.origin.y + labTips.frame.size.height+EDGE_SPACING;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
}

- (OHAttributedLabel*)createLableWithAttributeString:(NSAttributedString*)attStr origin:(CGPoint)ptOrigin width:(CGFloat)fWidth
{
    OHAttributedLabel* attLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    attLabel.backgroundColor = [UIColor clearColor];
    attLabel.attributedText = attStr;
    CGSize labelSize = [attStr sizeConstrainedToSize:CGSizeMake(fWidth, FLT_MAX)];
    attLabel.frame = CGRectMake(ptOrigin.x, ptOrigin.y, labelSize.width, labelSize.height);
    return attLabel;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (void)buttonReturn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)buttonMusic:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.audioPlayer.playing == NO)
    {
        [appDelegate.audioPlayer play];
    }
    else
    {
        [appDelegate.audioPlayer stop];
    }
    UIButton *btnMusic = sender;
    btnMusic.selected = !appDelegate.audioPlayer.playing;
}
- (void)buttonTimer:(id)sender
{
    TimerViewController *tvc = [[TimerViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tvc];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
    nav.view.superview.bounds = RECT_TIMERMODULVIEW;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setName:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
