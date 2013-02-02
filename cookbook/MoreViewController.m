//
//  MoreViewController.m
//  cookbook
//
//  Created by silvon on 13-1-31.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "MoreViewController.h"
#import <Parse/Parse.h>

#define ITEM_RECT          CGRectMake(0, 0,  100, 120)
#define ITEM_IMAGE_RECT    CGRectMake(0, 0,  100, 100)
#define ITEM_NAME_RECT     CGRectMake(0, 102,100, 20)
#define ITEM_SPACING       30
#define ITEM_FONTSIZE      15

#define RECIPEAPPGRID_EDGE_TB   20
#define RECIPEAPPGRID_EDGE_LR   44
#define RECIPEAPPGRID_FRAME     CGRectMake(0, 0, 580, 322)

#define QUERY_CLASS_NAME        @"recipeAPP"
#define QUERY_FIELD_APPNAME     @"appname"
#define QUERY_FIELD_URL         @"appstoreurl"
#define QUERY_FIELD_ICON        @"icon"

@interface MoreViewController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation UINavigationBar (customNav)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = CGSizeMake(self.frame.size.width, 58);
    return newSize;
}

@end

@implementation MoreViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_more.png"]];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_moreNav.png"] forBarMetrics:UIBarMetricsDefault];

    UIImage *btnImg = [UIImage imageNamed:@"btn_moreclose.png"];
    UIBarButtonItem *btnMoreClose = [[UIBarButtonItem alloc] initWithImage:btnImg style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [btnMoreClose setTintColor:[UIColor clearColor]];
    self.navigationItem.rightBarButtonItem = btnMoreClose;
    
    UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ind.frame = RECIPEAPPGRID_FRAME;
    [self.view addSubview:ind];
    [ind startAnimating];
    
    // GIRD
    PFQuery *query = [PFQuery queryWithClassName:QUERY_CLASS_NAME];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
       
        self.data = objects;
        self.appGridView = [[GMGridView alloc] initWithFrame:RECIPEAPPGRID_FRAME];
        self.appGridView.style = GMGridViewStyleSwap;
        self.appGridView.itemSpacing = ITEM_SPACING;
        self.appGridView.minEdgeInsets = UIEdgeInsetsMake(RECIPEAPPGRID_EDGE_TB, RECIPEAPPGRID_EDGE_LR, RECIPEAPPGRID_EDGE_TB, RECIPEAPPGRID_EDGE_LR);
        self.appGridView.actionDelegate = self;
        self.appGridView.dataSource = self;
        self.appGridView.centerGrid = NO;
        self.appGridView.clipsToBounds = YES;
        self.appGridView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.appGridView];
        
        [ind stopAnimating];

    }];

}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return ITEM_RECT.size;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    PFImageView * iconImgView;
    UILabel *appNameLabel;
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.contentView = [[UIView alloc] initWithFrame:ITEM_RECT];
        iconImgView = [[PFImageView alloc] initWithFrame:ITEM_IMAGE_RECT];
        [cell.contentView addSubview:iconImgView];
        
        appNameLabel = [[UILabel alloc] initWithFrame:ITEM_NAME_RECT];
        appNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:ITEM_FONTSIZE];
        appNameLabel.textColor = [UIColor whiteColor];
        appNameLabel.backgroundColor = [UIColor clearColor];
        appNameLabel.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:appNameLabel];
        
        [iconImgView setTag:1];
        [appNameLabel setTag:2];
        
    }
    
    iconImgView  = (PFImageView*)[cell.contentView viewWithTag:1];
    appNameLabel = (UILabel*)[cell.contentView viewWithTag:2];

    PFObject *appItem = [self.data objectAtIndex:index];
    appNameLabel.text = [appItem objectForKey: QUERY_FIELD_APPNAME];
    iconImgView.file  = (PFFile *)[appItem objectForKey: QUERY_FIELD_ICON];
    [iconImgView loadInBackground];
    
    return cell;
    
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    PFObject *appItem = [self.data objectAtIndex:position];
    NSString *url = [appItem objectForKey:QUERY_FIELD_URL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
- (void)viewDidUnload
{
    [self setAppGridView:nil];
    [self setData:nil];
    [super viewDidUnload];
}
@end
