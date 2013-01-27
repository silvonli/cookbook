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
#define EDGE_SPACING        40
#define SEC_SPACING         18
#define INEDGE_SPACING      20

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
- (IBAction)buttonReturn:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 80, 0);
    CGRect scrollFrame = UIEdgeInsetsInsetRect(self.view.frame, inset);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    
    UIImage *image = [UIImage imageNamed:@"菜谱_背景.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
   
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
    labelName.font = [UIFont fontWithName:@"STHeitiSC-Light" size:42.0f];
    labelName.textColor = [UIColor colorWithRed:160.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];
    labelName.backgroundColor = [UIColor clearColor];
    labelName.text = self.name;
    [self.scrollView addSubview:labelName];
    
    CGRect hkRect    = hk.frame;
    CGRect nameRect  = labelName.frame;
    CGFloat widthFull  = 1024 - EDGE_SPACING - EDGE_SPACING;
    CGFloat widthNOPic = hkRect.origin.x - INEDGE_SPACING - nameRect.origin.x;
    
    CGRect  baseRect;
    CGFloat baseY;
    CGFloat maxWidth;
    NSAttributedString* attText;
    CGPoint ptOrigin;
    // 主料
    baseRect = nameRect;
    baseY    = baseRect.origin.y + baseRect.size.height + SEC_SPACING;
    attText  = [dataManager getRecipeIngredients:self.name];
    ptOrigin = CGPointMake(baseRect.origin.x, baseY);
    maxWidth = widthNOPic;
    OHAttributedLabel* labIngredients = [self createLableWithAttributeString:attText origin:ptOrigin width:maxWidth];
    [self.scrollView addSubview:labIngredients];
    
    // 调料
    baseRect = labIngredients.frame;
    baseY    = baseRect.origin.y + baseRect.size.height + SEC_SPACING;
    attText  = [dataManager getRecipeSeasoning:self.name];
    ptOrigin = CGPointMake(baseRect.origin.x, baseY);
    maxWidth = baseRect.origin.y + baseRect.size.height<hkRect.origin.y + hkRect.size.height ? widthNOPic : widthFull;
    OHAttributedLabel* labSeasoning = [self createLableWithAttributeString:attText origin:ptOrigin width:maxWidth];
    [self.scrollView addSubview:labSeasoning];
    
    // 操作
    baseRect = labSeasoning.frame;
    baseY    = MAX(baseRect.origin.y + baseRect.size.height + SEC_SPACING, hkRect.origin.y + hkRect.size.height);
    attText  = [dataManager getRecipeOpration:self.name];
    ptOrigin = CGPointMake(baseRect.origin.x, baseY);
    maxWidth = widthFull;
    OHAttributedLabel* labOpration = [self createLableWithAttributeString:attText origin:ptOrigin width:maxWidth];
    [self.scrollView addSubview:labOpration];
    
    // 贴士
    baseRect = labOpration.frame;
    baseY    = MAX(baseRect.origin.y + baseRect.size.height + SEC_SPACING, hkRect.origin.y + hkRect.size.height);
    attText  = [dataManager getRecipeTips:self.name];
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
- (IBAction)buttonMusic:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.audioPlayer.playing == NO)
    {
        [appDelegate.audioPlayer play];
    }
    else
    {
        [appDelegate.audioPlayer stop];
    }
}
- (IBAction)buttonTimer:(id)sender
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
