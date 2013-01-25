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

#define RECIPEITEM_SPACING    36
#define RECIPEITEM_SIZE       CGSizeMake(302, 201)
#define RECIPEITEM_EDGE_TOP   0
#define RECIPEITEM_EDGE_LEFT  28


@interface ViewController ()<GMGridViewDataSource, GMGridViewActionDelegate>

@property (nonatomic, strong) NSArray *currentData;
@property (nonatomic, weak) UIButton *currentButton;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryAll];
    self.currentButton = (UIButton*)[self.view viewWithTag:100];
    
    UIImage *image = [UIImage imageNamed:@"bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.recipeItemView.style = GMGridViewStyleSwap;
    self.recipeItemView.itemSpacing = RECIPEITEM_SPACING;
    self.recipeItemView.minEdgeInsets = UIEdgeInsetsMake(RECIPEITEM_EDGE_TOP, RECIPEITEM_EDGE_LEFT, 0, 0);
    self.recipeItemView.actionDelegate = self;
    self.recipeItemView.dataSource = self;
    self.recipeItemView.centerGrid = NO;
    //self.recipeItemView.pagingEnabled = YES;
    self.recipeItemView.clipsToBounds = YES;
    self.recipeItemView.backgroundColor = [UIColor clearColor];

}

- (IBAction)buttonAll:(id)sender
{    
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryAll];
    self.currentButton.selected = NO;
    self.currentButton = sender;
    self.currentButton.selected = YES;
    [self.recipeItemView reloadData];
}
- (IBAction)buttonSuChai:(id)sender
{ 
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryShuCai];
    self.currentButton.selected = NO;
    self.currentButton = sender;
    self.currentButton.selected = YES;
    [self.recipeItemView reloadData]; 
}
- (IBAction)buttonPaiGu:(id)sender
{
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryPaiGu];
    self.currentButton.selected = NO;
    self.currentButton = sender;
    self.currentButton.selected = YES;
    [self.recipeItemView reloadData];
}
- (IBAction)buttonZhuRou:(id)sender
{
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryZhuRou];
    self.currentButton.selected = NO;
    self.currentButton = sender;
    self.currentButton.selected = YES;
    [self.recipeItemView reloadData];
}
- (IBAction)buttonJiRou:(id)sender
{
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryJiRou];
    self.currentButton.selected = NO;
    self.currentButton = sender;
    self.currentButton.selected = YES;
    [self.recipeItemView reloadData];
}
- (IBAction)buttonNiuYang:(id)sender
{
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryNiuYang];
    self.currentButton.selected = NO;
    self.currentButton = sender;
    self.currentButton.selected = YES;
    [self.recipeItemView reloadData];
}
- (IBAction)buttonYuXia:(id)sender
{
    self.currentData = [dataManager getRecipesNameOfCategory:CBRecipeCategoryYuXia];
    self.currentButton.selected = NO;
    self.currentButton = sender;
    self.currentButton.selected = YES;
    [self.recipeItemView reloadData];
}

- (IBAction)buttonOpenURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.haochi123.com"]];
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
    return RECIPEITEM_SIZE;
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
    RecipeViewController * rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RVCIdentifier"];
    rvc.name = self.currentData[position];
    [self presentViewController:rvc animated:NO completion:nil];
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
    [self setRecipeItemView:nil];
    [self setCurrentButton:nil];
    [super viewDidUnload];
}
@end
