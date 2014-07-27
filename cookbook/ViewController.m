//
//  ViewController.m
//  cookbook
//
//  Created by silvon on 13-1-22.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "ViewController.h"
#import "RecipeItem.h"
#import "CBDataManager.h"
#import "RecipeViewController.h"
#import "AppDelegate.h"
#import "TimerViewController.h"
#import "MoreViewController.h"

// grid控件位置
#define RECIPEGRID_FRAME                 CGRectMake(320, 0,  784, 768)
#define RECIPEGRID_EDGE_TOPBOTTOM        36
#define RECIPEGRID_EDGE_LEFTRIGHT        28
#define RECIPEGRID_ITEM_SPACING          36
#define RECIPEGRID_ITEM_SIZE             CGSizeMake(302, 201)

// 按钮位置
#define RECT_CATEGORYBG                  CGRectMake(26, 168, 267, 432)
#define RECT_TITLEIMG                    CGRectMake(90, 217, 138, 33)
#define RECT_MOREBUTTON                  CGRectMake(155, 14, 154, 174)
#define RECT_MUSICBUTTON                 CGRectMake(9,  615, 170, 150)
#define RECT_TIMERBUTTON                 CGRectMake(181,619, 95,  154)
#define RECT_URLBUTTON                   CGRectMake(69, 505, 188, 67)

// 分类按钮位置
#define CATEGORYBUTTON_SIZE              CGSizeMake(99, 44)
#define CATEGORYBUTTON_COL1_X            61
#define CATEGORYBUTTON_COL2_X            166
#define CATEGORYBUTTON_INIT_Y            284
#define CATEGORYBUTTON_V_SPACING         13


@interface ViewController ()<GMGridViewDataSource, GMGridViewActionDelegate>

@property (nonatomic, strong) NSArray *currentData;
@property (nonatomic, weak)   UIButton *currentButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 背景
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
    // 图片
    UIImageView *categoryBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_category.png"]];
    categoryBG.frame = RECT_CATEGORYBG;
    categoryBG.contentMode = UIViewContentModeCenter;
    [self.view addSubview:categoryBG];
    
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_title.png"]];
    titleImg.frame = RECT_TITLEIMG;
    titleImg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:titleImg];
    
    // 按钮
    UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMore.frame = RECT_MOREBUTTON;
    [btnMore setBackgroundImage:[UIImage imageNamed:@"btn_more.png"] forState:UIControlStateNormal];
    [btnMore addTarget:self action:@selector(buttonMore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnMore];
    
    UIButton *btnTimer = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTimer.frame = RECT_TIMERBUTTON;
    [btnTimer setBackgroundImage:[UIImage imageNamed:@"btn_timer.png"] forState:UIControlStateNormal];
    [btnTimer addTarget:self action:@selector(buttonTimer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTimer];
    
    self.btnMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMusic.frame = RECT_MUSICBUTTON;
    [self.btnMusic setBackgroundImage:[UIImage imageNamed:@"btn_coffee.png"] forState:UIControlStateNormal];
    [self.btnMusic setBackgroundImage:[UIImage imageNamed:@"btn_coffeeplay.png"] forState:UIControlStateSelected];
    [self.btnMusic addTarget:self action:@selector(buttonMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnMusic];
    
    UIButton *btnURL = [UIButton buttonWithType:UIButtonTypeCustom];
    btnURL.frame = RECT_URLBUTTON;
    [btnURL setBackgroundImage:[UIImage imageNamed:@"btn_haochi123.png"] forState:UIControlStateNormal];
    [btnURL addTarget:self action:@selector(buttonOpenURL:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnURL];
    
    // 分类按钮
    for (int i = 0; i<[dataManager getCategoryCount]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        int x = i%2 == 0 ? CATEGORYBUTTON_COL1_X : CATEGORYBUTTON_COL2_X;
        int y = CATEGORYBUTTON_INIT_Y + (i/2) * (CATEGORYBUTTON_SIZE.height+CATEGORYBUTTON_V_SPACING);
        btn.frame = CGRectMake(x, y, CATEGORYBUTTON_SIZE.width, CATEGORYBUTTON_SIZE.height);
        NSString *imgName = [dataManager getCategoryImageName:i];
        NSInteger tag = [[dataManager getCategoryEnumValue:i] integerValue];
        [btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateSelected];
        [btn setTag:tag];
        [btn addTarget:self action:@selector(buttonCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    self.currentButton = (UIButton*)[self.view viewWithTag:CBRecipeCategoryAll];
    self.currentButton.selected = YES;
    // GIRD
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryAll];
    self.recipeGridView = [[GMGridView alloc] initWithFrame:RECIPEGRID_FRAME];
    self.recipeGridView.style = GMGridViewStyleSwap;
    self.recipeGridView.itemSpacing = RECIPEGRID_ITEM_SPACING;
    self.recipeGridView.minEdgeInsets = UIEdgeInsetsMake(RECIPEGRID_EDGE_TOPBOTTOM, RECIPEGRID_EDGE_LEFTRIGHT, RECIPEGRID_EDGE_TOPBOTTOM, 0);
    self.recipeGridView.actionDelegate = self;
    self.recipeGridView.dataSource = self;
    self.recipeGridView.centerGrid = NO;
    self.recipeGridView.clipsToBounds = YES;
    self.recipeGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recipeGridView];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.btnMusic.selected = !appDelegate.audioPlayer.playing;
}

- (void)buttonMore:(id)sender
{
    MoreViewController *mvc = [[MoreViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mvc];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
    nav.view.superview.bounds = RECT_MOREMODULVIEW;
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
    self.btnMusic.selected = !appDelegate.audioPlayer.playing;
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

- (void)buttonOpenURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.haochi123.com"]];
}

- (void)buttonCategory:(id)sender
{
    UIButton *btn = sender;
    self.currentData = [dataManager getRecipesNameOfCategory:btn.tag];
    self.currentButton.selected = NO;
    self.currentButton = btn;
    self.currentButton.selected = YES;
    
    self.recipeGridView.contentOffset = CGPointZero;
    [self.recipeGridView reloadData];
    
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return RECIPEGRID_ITEM_SIZE;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
  
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipeItem"owner:self options:nil];
        cell.contentView = [nib objectAtIndex:0];
    }
    
    RecipeItem *item = (RecipeItem *)cell.contentView;
    
    NSString *name = self.currentData[index];
    item.name.text = name;
    item.picture.image = [UIImage imageNamed: [dataManager getRecipePicture:name]];
    
    return cell;
    
}



//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    RecipeViewController * rvc = [[RecipeViewController alloc] initWithNibName:nil bundle:nil];
    rvc.name = self.currentData[position];
    rvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:rvc animated:YES completion:nil];
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

- (void)viewDidUnload {
    [self setRecipeGridView:nil];
    [self setBtnMusic:nil];
    [self setCurrentData:nil];
    [super viewDidUnload];
}
@end
