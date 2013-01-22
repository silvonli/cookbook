//
//  ViewController.m
//  cookbook
//
//  Created by silvon on 13-1-22.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "ViewController.h"
#import "RecipeItem.h"

#define RECIPEITEM_SPACING    36
#define RECIPEITEM_SIZE       CGSizeMake(302, 201)
#define RECIPEITEM_EDGE_TOP   10
#define RECIPEITEM_EDGE_LEFT  28

#define CATEGORYITEM_SPACING  20
#define CATEGORYITEM_SIZE     CGSizeMake(66, 35)
#define CATEGORYITEM_EDGE_TOP   50
#define CATEGORYITEM_EDGE_LEFT  30

@interface ViewController ()<GMGridViewDataSource, GMGridViewActionDelegate>

@property(nonatomic, strong) NSMutableArray *data;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.data = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i ++)
    {
        [self.data addObject:[NSString stringWithFormat:@"A %d", i]];
    }
    
    self.currentButton = (UIButton*)[self.view viewWithTag:100];

    
    UIImage *image = [UIImage imageNamed:@"bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.recipeItemView.style = GMGridViewStyleSwap;
    self.recipeItemView.itemSpacing = RECIPEITEM_SPACING;
    self.recipeItemView.minEdgeInsets = UIEdgeInsetsMake(RECIPEITEM_EDGE_TOP, RECIPEITEM_EDGE_LEFT, 0, 0);
    self.recipeItemView.actionDelegate = self;
    self.recipeItemView.dataSource = self;
    self.recipeItemView.centerGrid = NO;
    self.recipeItemView.pagingEnabled = YES;
    self.recipeItemView.clipsToBounds = YES;
    self.recipeItemView.backgroundColor = [UIColor clearColor];

    

}


- (IBAction)buttonTapped:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_current_queue(), ^{
        self.currentButton.selected = NO;
        self.currentButton = sender;
        self.currentButton.selected = YES;
    });
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
    return [self.data count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return RECIPEITEM_SIZE;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    

    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        
        UIImage *img = [UIImage imageNamed:@"葱爆羊肉1.jpg"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipeItem"owner:self options:nil];
        RecipeItem *item  = [nib objectAtIndex:0];
        item.name.text = @"skdfjakd;f";
        item.name.textColor = [UIColor blackColor];
        item.image.image = img;
        
        cell.contentView = item;
    }
    
    return cell;
    
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO; //index % 2 == 0;
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRecipeItemView:nil];
    [self setCategoryView:nil];
    [super viewDidUnload];
}
@end
