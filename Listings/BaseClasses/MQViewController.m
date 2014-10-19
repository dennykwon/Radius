//
//  MQViewController.m
//  Listings
//
//  Created by Dan Kwon on 9/5/14.
//  Copyright (c) 2014 Mercury. All rights reserved.
//

#import "MQViewController.h"

@implementation MQViewController
@synthesize profile;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.profile = [MQProfile sharedProfile];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loadingIndicator = [[MQLoadingIndicator alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    self.loadingIndicator.alpha = 0.0f;
    [self.view addSubview:self.loadingIndicator];
    
}

- (UIView *)baseView:(BOOL)navCtr
{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    if (navCtr){
        
        // account for nav bar height, only necessary in iOS 7!
        frame.size.height -= 44.0f;
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIFont fontWithName:@"HelveticaNeue" size:18.0f],
          NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        
    }
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
    return view;
}

- (void)addNavigationTitleView
{
    static CGFloat width = 200.0f;
    static CGFloat height = 46.0f;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    titleView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
    titleView.backgroundColor = [UIColor clearColor];
    UIImage *imgLogo = [UIImage imageNamed:@"logo.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:imgLogo];
    static double scale = 0.7f;
    CGRect frame = logo.frame;
    frame.size.width = scale*imgLogo.size.width;
    frame.size.height = scale*imgLogo.size.height;
    logo.frame = frame;
    logo.center = CGPointMake(0.45f*width, 24.0f);
    
    [titleView addSubview:logo];
    
    self.navigationItem.titleView = titleView;
    
}


- (void)shiftUp:(CGFloat)distance
{
    [UIView animateWithDuration:0.21f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = -distance;
                         self.view.frame = frame;
                     }
                     completion:NULL];
}

- (void)shiftBack:(CGFloat)origin
{
    [UIView animateWithDuration:0.21f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = origin; // accounts for nav bar
                         self.view.frame = frame;
                     }
                     completion:NULL];
    
}


#pragma mark - Alert
- (void)showAlertWithtTitle:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)showAlertWithOptions:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
