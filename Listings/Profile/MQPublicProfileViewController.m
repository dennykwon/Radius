//
//  MQPublicProfileViewController.m
//  Listings
//
//  Created by Dan Kwon on 11/1/14.
//  Copyright (c) 2014 Mercury. All rights reserved.


#import "MQPublicProfileViewController.h"
#import "MQReferencesViewController.h"
#import "MQWebViewController.h"
#import "MQResumeViewController.h"
#import "MQSignupViewController.h"
#import "MQLoginViewController.h"
#import "MQSubmitIntroViewController.h"
#import "MQWebServices.h"


@interface MQPublicProfileViewController ()
@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UIImageView *blurryBackground;
@property (strong, nonatomic) UIScrollView *theScrollview;
@property (strong, nonatomic) UIImageView *profileIcon;
@property (strong, nonatomic) UILabel *lblProfileName;
@property (strong, nonatomic) UILabel *lblLocation;
@property (strong, nonatomic) UILabel *lblSchool; // may be nil
@property (strong, nonatomic) UILabel *lblBio;
@end

@implementation MQPublicProfileViewController
@synthesize publicProfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = @"Profile";

    }
    return self;
}


- (void)dealloc
{
    [self.theScrollview removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    UIImage *bgImage = [UIImage imageNamed:@"bgSidewalkGray.png"];
    self.background = [[UIImageView alloc] initWithImage:bgImage];
    self.background.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
    self.background.frame = CGRectMake(0.0f, 0.0f, bgImage.size.width, bgImage.size.height);
    [view addSubview:self.background];
    
    self.blurryBackground = [[UIImageView alloc] initWithImage:[bgImage applyBlurOnImage:0.95f]];
    self.blurryBackground.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
    self.blurryBackground.frame = CGRectMake(0.0f, 0.0f, bgImage.size.width, bgImage.size.height);
    self.blurryBackground.alpha = 0.0f;
    [view addSubview:self.blurryBackground];
    
    UIColor *white = [UIColor whiteColor];
    UIColor *clear = [UIColor clearColor];

    
    CGFloat dimen = 70.0f;
    self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dimen, dimen)];
    self.profileIcon.center = CGPointMake(0.5f*frame.size.width, 46.0f);
    self.profileIcon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.profileIcon.image = (self.publicProfile.imageData) ? self.publicProfile.imageData : [UIImage imageNamed:@"logo.png"];
    self.profileIcon.layer.cornerRadius = 0.5f*dimen;
    self.profileIcon.layer.masksToBounds = YES;
    self.profileIcon.layer.borderColor = [white CGColor];
    self.profileIcon.layer.borderWidth = 2.0f;
    [view addSubview:self.profileIcon];
    CGFloat y = self.profileIcon.frame.origin.y+self.profileIcon.frame.size.height+4.0f;

    
    self.lblProfileName = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 22.0f)];
    self.lblProfileName.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.lblProfileName.textColor = white;
    self.lblProfileName.textAlignment = NSTextAlignmentCenter;
    self.lblProfileName.text = [NSString stringWithFormat:@"%@ %@", self.publicProfile.firstName.uppercaseString, self.publicProfile.lastName.uppercaseString];
    self.lblProfileName.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    [view addSubview:self.lblProfileName];
    y += self.lblProfileName.frame.size.height;
    
    if (self.publicProfile.schools.count > 0){
        self.lblSchool = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 16.0f)];
        self.lblSchool.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.lblSchool.textColor = white;
        self.lblSchool.textAlignment = NSTextAlignmentCenter;
        self.lblSchool.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
        self.lblSchool.text = [self.publicProfile.schools[0] capitalizedString];
        [view addSubview:self.lblSchool];
        y += self.lblSchool.frame.size.height;
    }

    self.lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 16.0f)];
    self.lblLocation.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.lblLocation.textColor = white;
    self.lblLocation.textAlignment = NSTextAlignmentCenter;
    self.lblLocation.text = [NSString stringWithFormat:@"%@, %@", [self.publicProfile.city capitalizedString], self.publicProfile.state.uppercaseString];
    self.lblLocation.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    [view addSubview:self.lblLocation];
    y += self.lblLocation.frame.size.height+40.0f;


    self.theScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
    self.theScrollview.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
    self.theScrollview.backgroundColor = clear;
    self.theScrollview.showsVerticalScrollIndicator = NO;
    self.theScrollview.delegate = self;
    [self.theScrollview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPhoto:)]];
    
    
    UIView *base = [[UIView alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 800.0f)];
    base.backgroundColor = clear;
    
    UIFont *font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    CGRect boundingRect = [self.publicProfile.bio boundingRectWithSize:CGSizeMake(frame.size.width-24.0f, 220.0f)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:font}
                                                               context:nil];
    
    CGFloat padding = 12.0f;
    CGFloat width = frame.size.width-2*padding;
    y = padding+4.0f;
    self.lblBio = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, width, boundingRect.size.height)];
    self.lblBio.textColor = white;
    self.lblBio.numberOfLines = 0;
    self.lblBio.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblBio.textAlignment = NSTextAlignmentCenter;
    self.lblBio.font = font;
    self.lblBio.text = ([self.publicProfile.bio isEqualToString:@"none"]) ? @"" : self.publicProfile.bio;
    [base addSubview:self.lblBio];
    y += boundingRect.size.height+2.5f*padding;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(padding, y, width, 0.5f)];
    line.backgroundColor = white;
    [base addSubview:line];
    y += 1.5f*padding;
    
    UILabel *lblSkillsHeader = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, width, 16.0f)];
    lblSkillsHeader.textAlignment = NSTextAlignmentCenter;
    lblSkillsHeader.textColor = white;
    lblSkillsHeader.text = @"SKILLS";
    lblSkillsHeader.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    [base addSubview:lblSkillsHeader];
    y += lblSkillsHeader.frame.size.height+1.5f*padding;
    
    font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    NSString *skillsString = [self.publicProfile.skills componentsJoinedByString:@", "];
    boundingRect = [skillsString boundingRectWithSize:CGSizeMake(frame.size.width-24.0f, 220.0f)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];

    UILabel *lblSkills = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, width, boundingRect.size.height+padding)];
    lblSkills.textAlignment = NSTextAlignmentCenter;
    lblSkills.textColor = [UIColor darkGrayColor];
    lblSkills.font = font;
    lblSkills.backgroundColor = kBaseGray;
    lblSkills.alpha = 0.7f;
    lblSkills.numberOfLines = 0;
    lblSkills.lineBreakMode = NSLineBreakByWordWrapping;
    lblSkills.layer.borderWidth = 0.5f;
    lblSkills.layer.borderColor = [white CGColor];
    lblSkills.layer.cornerRadius = 3.0f;
    lblSkills.layer.masksToBounds = YES;
    lblSkills.text = skillsString;
    [base addSubview:lblSkills];
    y += lblSkills.frame.size.height+2.5f*padding;
    
    line = [[UIView alloc] initWithFrame:CGRectMake(padding, y, width, 0.5f)];
    line.backgroundColor = white;
    [base addSubview:line];
    y += 1.5f*padding;

    UILabel *lblMoreHeader = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, width, 16.0f)];
    lblMoreHeader.textAlignment = NSTextAlignmentCenter;
    lblMoreHeader.textColor = white;
    lblMoreHeader.text = @"MORE";
    lblMoreHeader.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    [base addSubview:lblMoreHeader];
    y += lblMoreHeader.frame.size.height+1.5f*padding;
    
    NSMutableArray *more = [NSMutableArray arrayWithArray:@[@"Resume", @"References"]];
    if ([self.publicProfile.facebookId isEqualToString:@"none"]==NO)
        [more addObject:@"Facebook"];

    if ([self.publicProfile.twitterId isEqualToString:@"none"]==NO)
        [more addObject:@"Twitter"];

    if ([self.publicProfile.linkedinId isEqualToString:@"none"]==NO)
        [more addObject:@"Linkedin"];

    
    UIImage *arrow = [UIImage imageNamed:@"forwardArrow.png"];
    UIFont *btnFont = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    UIColor *black = [UIColor blackColor];
    for (int i=0; i<more.count; i++){
        UIView *bgMore = [[UIView alloc] initWithFrame:CGRectMake(padding, y, width, 44.0f)];
        bgMore.backgroundColor = clear;
        
        UIView *bgBlack = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, bgMore.frame.size.height)];
        bgBlack.backgroundColor = black;
        bgBlack.alpha = 0.50f;
        [bgMore addSubview:bgBlack];
        
        UIButton *btnOption = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOption.frame = CGRectMake(0.0f, 0.0f, width, bgMore.frame.size.height);
        btnOption.titleLabel.textColor = white;
        btnOption.titleLabel.font = btnFont;
        btnOption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnOption setTitle:[NSString stringWithFormat:@"   %@", more[i]] forState:UIControlStateNormal];
        [btnOption addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
        [bgMore addSubview:btnOption];
        
        UIImageView *imgForwardArrow = [[UIImageView alloc] initWithImage:arrow];
        imgForwardArrow.frame = CGRectMake(0, 0, 0.7f*imgForwardArrow.frame.size.width, 0.7f*imgForwardArrow.frame.size.height);
        imgForwardArrow.center = CGPointMake(width-16.0f, 22.0f);
        [bgMore addSubview:imgForwardArrow];
        [base addSubview:bgMore];
        
        y += bgMore.frame.size.height+4.0f;
    }

    
    y += 2.5f*padding;

    UIView *connect = [[UIView alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 64.0f)];
    connect.backgroundColor = [UIColor grayColor];
    connect.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIButton *btnConnect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnConnect.frame = CGRectMake(12.0, 12.0f, frame.size.width-24.0f, 44.0f);
    btnConnect.backgroundColor = clear;
    btnConnect.layer.borderColor = [white CGColor];
    btnConnect.layer.borderWidth = 1.5f;
    btnConnect.layer.cornerRadius = 4.0f;
    btnConnect.layer.masksToBounds = YES;
    btnConnect.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    [btnConnect setTitle:@"CONNECT" forState:UIControlStateNormal];
    [btnConnect setTitleColor:white forState:UIControlStateNormal];
    [btnConnect addTarget:self action:@selector(contactProfile:) forControlEvents:UIControlEventTouchUpInside];
    [connect addSubview:btnConnect];
    
    [base addSubview:connect];
    y += connect.frame.size.height;

    
    
    [self.theScrollview addSubview:base];

    self.theScrollview.contentSize = CGSizeMake(0.0f, base.frame.origin.y+y+padding+8.0f);
    [self.theScrollview addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [view addSubview:self.theScrollview];

    
    [self setupFullImage:view];

    
    self.view = view;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCustomBackButton];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *publicProfileId = self.publicProfile.uniqueId;
    
    NSLog(@"%@", [self.session.profilesViewed description]);
    
    if ([self.session.profilesViewed containsObject:publicProfileId]==YES)
        return;
    
    [[MQWebServices sharedInstance] incrementView:self.publicProfile completion:^(id result, NSError *error){
        if (error){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.session.profilesViewed addObject:publicProfileId];
        });
        
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]){
        CGFloat offset = self.theScrollview.contentOffset.y;
        if (offset < 0.0f){
            offset *= -1;
            double diff = offset;
            double factor = diff/250.0f;
            
            CGAffineTransform transform = CGAffineTransformMakeScale(1.0f+factor, 1.0f+factor);
            self.background.transform = transform;
            self.profileIcon.transform = transform;
            self.profileIcon.alpha = 1.0f;
            self.lblProfileName.alpha = 1.0f;
            self.lblLocation.alpha = 1.0f;
            self.lblSchool.alpha = 1.0f;
            return;
        }
        
        double distance = offset;
        if (distance < 500.0f){
            CGRect frame = self.blurryBackground.frame;
            frame.origin.y = -0.25f*distance;
            self.blurryBackground.frame = frame;
            self.background.frame = frame;
        }
        
        self.profileIcon.alpha = 1.0f-(distance/75.0f);
        self.lblProfileName.alpha = self.profileIcon.alpha;
        self.lblLocation.alpha = self.profileIcon.alpha;
        self.lblSchool.alpha = self.profileIcon.alpha;
        
        // closer to zero, less blur applied
        double blurFactor = (offset + self.theScrollview.contentInset.top) / (2 * CGRectGetHeight(self.theScrollview.bounds) / 3.5f);
        self.blurryBackground.alpha = blurFactor;
    }
}

- (void)back:(UIBarButtonItem *)btn
{
    if (self.fullImageView.alpha==1.0f){
        [self exitFullImage:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectOption:(UIButton *)btn
{
    NSString *option = [btn.titleLabel.text lowercaseString];
    option = [option stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"selectOption: %@", option);
    
    if ([option isEqualToString:@"resume"]){
        if (self.profile.populated){ // only registered users can view resume
            if ([self.publicProfile.resume isEqualToString:@"none"]){
                NSString *fullName = [NSString stringWithFormat:@"%@ %@", [self.publicProfile.firstName capitalizedString], [self.publicProfile.lastName capitalizedString]];
                NSString *msg = [NSString stringWithFormat:@"%@ does not have a resume linked to this account.", fullName];
                [self showAlertWithtTitle:@"No Resume" message:msg];
                return;
            }
            
            MQWebViewController *webVc = [[MQWebViewController alloc] init];
            webVc.address = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"site/pdf/%@", self.publicProfile.resume]];
            [self.navigationController pushViewController:webVc animated:YES];
            return;
        }
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"View Resume" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sign Up", @"Log In", nil];
        actionsheet.frame = CGRectMake(0.0f, 150.0f, self.view.frame.size.width, 100.0f);
        actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
    if ([option isEqualToString:@"references"]){
        MQReferencesViewController *referencesVc = [[MQReferencesViewController alloc] init];
        referencesVc.publicProfile = self.publicProfile;
        [self.navigationController pushViewController:referencesVc animated:YES];
        
    }

    if ([option isEqualToString:@"facebook"]){
        MQWebViewController *webVc = [[MQWebViewController alloc] init];
        webVc.address = [NSString stringWithFormat:@"https://www.facebook.com/%@", self.publicProfile.facebookId];
        [self.navigationController pushViewController:webVc animated:YES];
    }

    if ([option isEqualToString:@"twitter"]){
        MQWebViewController *webVc = [[MQWebViewController alloc] init];
        webVc.title = @"Twitter";
        webVc.address = [NSString stringWithFormat:@"https://twitter.com/intent/user?user_id=%@", self.publicProfile.twitterId];
        [self.navigationController pushViewController:webVc animated:YES];
    }
    
    if ([option isEqualToString:@"linkedin"]){
        MQWebViewController *webVc = [[MQWebViewController alloc] init];
        webVc.address = [NSString stringWithFormat:@"http://www.linkedin.com/profile/view?id=%@", self.publicProfile.linkedinId];
        [self.navigationController pushViewController:webVc animated:YES];
    }


}

- (void)contactProfile:(UIButton *)btn
{
    NSLog(@"contactProfile:");
    if (self.profile.populated){
        MQSubmitIntroViewController *submitIntroVc = [[MQSubmitIntroViewController alloc] init];
        submitIntroVc.publicProfile = self.publicProfile;
        [self.navigationController pushViewController:submitIntroVc animated:YES];
        return;
    }
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Connect" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sign Up", @"Log In", nil];
    actionsheet.frame = CGRectMake(0.0f, 150.0f, self.view.frame.size.width, 100.0f);
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)viewPhoto:(UIGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.theScrollview];
    if (location.y > 120.0f)
        return;
    
    
    [self viewFullImage:self.publicProfile.imageData];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging: %.2f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -80.0f)
        [self viewFullImage:self.publicProfile.imageData];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet clickedButtonAtIndex: %d", (int)buttonIndex);
    
    if (buttonIndex==0) { // sign up
        MQSignupViewController *signupVc = [[MQSignupViewController alloc] init];
        UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:signupVc];
        [self presentViewController:navCtr animated:YES completion:^{
            
        }];
    }
    
    if (buttonIndex==1) { // log in
        MQLoginViewController *loginVc = [[MQLoginViewController alloc] init];
        UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:navCtr animated:YES completion:^{
            
        }];
        
    }
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
