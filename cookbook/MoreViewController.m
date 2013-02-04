//
//  MoreViewController.m
//  cookbook
//
//  Created by silvon on 13-1-31.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "MoreViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#define ITEM_RECT          CGRectMake(0, 0,  86, 100)
#define ITEM_IMAGE_RECT    CGRectMake(0, 0,  86, 86)
#define ITEM_NAME_RECT     CGRectMake(0, 88, 86, 14)
#define ITEM_SPACING       40
#define ITEM_FONTSIZE      13

#define RECIPEAPPGRID_EDGE_TB   36
#define RECIPEAPPGRID_EDGE_LR   54

#define SUPERVIEW_FRAME         CGRectMake(0, 0, 572, 372)
#define RECIPEAPPGRID_FRAME     CGRectMake(0, 0, 572, 318)
#define NAV_HEIGHT              54
#define CLOSEBUTTON_FRAME       CGRectMake(0, 0, 37,  37)
 

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
    CGSize newSize = CGSizeMake(self.frame.size.width, NAV_HEIGHT);
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
    
    // 导航栏
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_moreNav.png"] forBarMetrics:UIBarMetricsDefault];

    // 关闭按钮
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CLOSEBUTTON_FRAME];
    [btnClose setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    btnClose.contentEdgeInsets = UIEdgeInsetsMake(-10, -6, 0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnClose];;
    
    // 活动指示
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
    iconImgView.image = [UIImage imageNamed:@"holdplace"];
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
