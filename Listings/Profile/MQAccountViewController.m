//
//  MQAccountViewController.m
//  Listings
//
//  Created by Dan Kwon on 10/17/14.
//  Copyright (c) 2014 Mercury. All rights reserved.
//

#import "MQAccountViewController.h"
#import "MQProfileViewController.h"
#import "MQReferencesViewController.h"
#import "MQProfileListingsViewController.h"


@interface MQAccountViewController ()
@property (strong, nonatomic) NSMutableArray *panels;
@property (nonatomic) BOOL loaded;
@end

@implementation MQAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.panels = [NSMutableArray array];
        self.loaded = NO;
        
        UIImage *imgHeader = [UIImage imageNamed:@"header.png"];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgHeader.size.width, imgHeader.size.height)];
        header.backgroundColor = [UIColor colorWithPatternImage:imgHeader];
        self.navigationItem.titleView = header;
    }
    return self;
}


- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgBlurry1Red.png"]];
    
    CGFloat height = view.frame.size.height/4.0f;
    CGFloat width = frame.size.width;
    CGFloat alpha = 0.65f;
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    UIFont *detailFont = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    
    NSArray *sections = @[@{@"title":@"Profile", @"details":@"Manage your profile details", @"icon":@"iconProfile.png", @"color":kOrange}, @{@"title":@"Applied", @"details":@"View your job applications", @"icon":@"iconCheckMark.png", @"color":[UIColor darkGrayColor]}, @{@"title":@"Saved", @"details":@"View your saved jobs", @"icon":@"iconSave.png", @"color":kGreen}, @{@"title":@"References", @"details":@"Improve your profile with references", @"icon":@"iconComment.png", @"color":kLightBlue}];

    for (int i=0; i<sections.count; i++){
        NSDictionary *section = sections[i];
        UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0.0f, frame.size.height, width, height)];
        panel.tag = 1000+i;
        panel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [panel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionSelected:)]];
        
        UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height+1.0f)];
        background.backgroundColor = (UIColor *)section[@"color"];
        background.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        background.alpha = alpha;
        [panel addSubview:background];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:section[@"icon"]]];
        icon.center = CGPointMake(0.5f*frame.size.width, 0.25f*panel.frame.size.height);
        [panel addSubview:icon];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 22.0f)];
        lblTitle.center = CGPointMake(lblTitle.center.x, 0.5f*panel.frame.size.height+4.0f);
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = [UIColor whiteColor];
        lblTitle.font = titleFont;
        lblTitle.text = section[@"title"];
        [panel addSubview:lblTitle];
        
        UILabel *lblDetails = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, 22.0f)];
        lblDetails.center = CGPointMake(lblDetails.center.x, 0.5f*panel.frame.size.height+22.0f);
        lblDetails.textAlignment = NSTextAlignmentCenter;
        lblDetails.textColor = [UIColor whiteColor];
        lblDetails.font = detailFont;
        lblDetails.text = section[@"details"];
        [panel addSubview:lblDetails];

        [view addSubview:panel];
        [self.panels addObject:panel];
    }
    

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barTintColor = kGreen;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary *titleAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:18.0f], NSForegroundColorAttributeName : self.navigationController.navigationBar.tintColor};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttributes];
    
    UIImage *imgExit = [UIImage imageNamed:@"exit.png"];
    UIButton *btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnExit.frame = CGRectMake(0.0f, 0.0f, 0.7f*imgExit.size.width, 0.7f*imgExit.size.height);
    [btnExit setBackgroundImage:imgExit forState:UIControlStateNormal];
    [btnExit addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnExit];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.loaded)
        return;
    
    CGFloat y = 64.0f;
    for (int i=0; i<self.panels.count; i++) {
        UIView *panel = self.panels[i];
        
        [UIView animateWithDuration:1.50f
                              delay:0.20*i
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             panel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
                             CGRect frame = panel.frame;
                             frame.origin.y = y;
                             panel.frame = frame;
                         }
                         completion:^(BOOL finished){
                             self.loaded = YES;
                         }];
        
        y += panel.frame.size.height+1.0f;
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)exit
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sectionSelected:(UIGestureRecognizer *)tap
{
    int tag = (int)tap.view.tag;
    NSLog(@"sectionSelected: %d", tag);
    
    if (tag==1000){ // profile
        MQProfileViewController *profileVc = [[MQProfileViewController alloc] init];
        [self.navigationController pushViewController:profileVc animated:YES];
    }
    
    if (tag==1001){ // Applications
        MQProfileListingsViewController *applicationsVc = [[MQProfileListingsViewController alloc] init];
        [self.navigationController pushViewController:applicationsVc animated:YES];
    }

    if (tag==1002){ // Saved Listings
        MQProfileListingsViewController *savedVc = [[MQProfileListingsViewController alloc] init];
        savedVc.mode = @"saved";
        [self.navigationController pushViewController:savedVc animated:YES];
    }
    
    if (tag==1003){ // references
        MQReferencesViewController *referencesVc = [[MQReferencesViewController alloc] init];
        [self.navigationController pushViewController:referencesVc animated:YES];
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
