//
//  RecipeViewController.m
//  cookbook
//
//  Created by silvon on 13-1-24.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "RecipeViewController.h"
#import "CBDataManager.h"
#import "TTTAttributedLabel/TTTAttributedLabel.h"

#define EDGE_SPACING        40
#define PARAGRAPH_SPACING   30 
#define PICTURE_SPACING     20
#define BUTTON_SPACING      160
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
    
    UIImage *image = [UIImage imageNamed:@"菜谱_背景.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
  
    
    UIImage *imgHK = [UIImage imageNamed:@"菜谱_画框.png"];
    self.picture.backgroundColor = [UIColor colorWithPatternImage:imgHK];
    self.picture.image = [UIImage imageNamed: [dataManager getRecipePicture:self.name]];
    
    self.labelName.text = self.name;
    
    // 创建 label
    UIFont *textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:22.0f];
    const CGRect picRect   = self.picture.frame;
    const CGRect nameRect  = self.labelName.frame;    
    const CGFloat widthFull  = 1024 - EDGE_SPACING - EDGE_SPACING - BUTTON_SPACING;
    const CGFloat widthNOPic = picRect.origin.x - PICTURE_SPACING - nameRect.origin.x;
    
    CGRect baseRect;
    CGFloat maxWidth;
    CGSize labSize;
    
    // 主料
    baseRect = nameRect;
    maxWidth = baseRect.origin.y + baseRect.size.height<picRect.origin.y + picRect.size.height ? widthNOPic : widthFull;
    TTTAttributedLabel* labIngredients = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    labIngredients.backgroundColor = [UIColor clearColor];
    labIngredients.numberOfLines = 0;
    labIngredients.font = textFont;
    //labIngredients.text = [dataManager getRecipeIngredients:self.name];
    
    labIngredients.attributedText = [dataManager getRecipeIngredients:self.name];
    
    labSize = [[labIngredients.attributedText string] sizeWithFont:textFont
                              constrainedToSize:CGSizeMake(maxWidth, FLT_MAX)
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    labIngredients.frame = CGRectMake(baseRect.origin.x,
                                      baseRect.origin.y + baseRect.size.height + PARAGRAPH_SPACING,
                                      labSize.width,
                                      labSize.height);
    
    [self.view addSubview:labIngredients];
    
    // 调料
    baseRect = labIngredients.frame;
    maxWidth = baseRect.origin.y + baseRect.size.height<picRect.origin.y + picRect.size.height ? widthNOPic : widthFull;
    TTTAttributedLabel* labSeasoning = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    labSeasoning.backgroundColor = [UIColor clearColor];
    labSeasoning.numberOfLines = 0;
    labSeasoning.font = textFont;
    labSeasoning.text = [dataManager getRecipeSeasoning:self.name];
    
    labSize = [labSeasoning.text sizeWithFont:textFont
                           constrainedToSize:CGSizeMake(maxWidth, FLT_MAX)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    labSeasoning.frame = CGRectMake(baseRect.origin.x,
                                    baseRect.origin.y + baseRect.size.height + PARAGRAPH_SPACING,
                                    labSize.width,
                                    labSize.height);
    
    [self.view addSubview:labSeasoning];
    
    // 操作
    baseRect = labSeasoning.frame;
    maxWidth = baseRect.origin.y + baseRect.size.height<picRect.origin.y + picRect.size.height ? widthNOPic : widthFull;
    TTTAttributedLabel* labOpration = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    labOpration.backgroundColor = [UIColor clearColor];
    labOpration.numberOfLines = 0;
    labOpration.font = textFont;
    labOpration.text = [dataManager getRecipeOpration:self.name];
    
    labSize = [labOpration.text sizeWithFont:textFont
                           constrainedToSize:CGSizeMake(maxWidth, FLT_MAX)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    labOpration.frame = CGRectMake(baseRect.origin.x,
                                      baseRect.origin.y + baseRect.size.height + PARAGRAPH_SPACING,
                                      labSize.width,
                                      labSize.height);

    [self.view addSubview:labOpration];
    
    // 贴士
    baseRect = labOpration.frame;
    maxWidth = baseRect.origin.y + baseRect.size.height<picRect.origin.y + picRect.size.height ? widthNOPic : widthFull;
    TTTAttributedLabel* labTips = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    labTips.backgroundColor = [UIColor clearColor];
    labTips.numberOfLines = 0;
    labTips.font = textFont;
    labTips.text = [dataManager getRecipeTips:self.name];
    
    labSize = [labTips.text sizeWithFont:textFont
                           constrainedToSize:CGSizeMake(maxWidth, FLT_MAX)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    labTips.frame = CGRectMake(baseRect.origin.x,
                                   baseRect.origin.y + baseRect.size.height + PARAGRAPH_SPACING,
                                   labSize.width,
                                   labSize.height);
    
    [self.view addSubview:labTips];

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
    [self setLabelName:nil];
    [self setPicture:nil];
    [super viewDidUnload];
}
@end
