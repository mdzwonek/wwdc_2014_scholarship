//
//  ContentViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "ContentViewController.h"
#import <MDSDK/MDSDK.h>
#import "WelcomeViewController.h"
#import "ExperienceViewController.h"
#import "ResumeViewController.h"
#import "HobbiesViewController.h"
#import "IPadBugReport.h"


static const CGFloat ContentViewAnchorPointX = 1.75f;

static const CGFloat ContentViewMinimumAngle = -10.0f;
static const CGFloat ContentViewMaximumTranslation = -100.0f;
static const CGFloat ContentViewM34 = 1.0f / -250.0f;


@interface ContentViewController () <UINavigationControllerDelegate>

@property (nonatomic) UINavigationController *currentNavigationController;

@property (nonatomic) IBOutlet UIView *navigationBarView;
@property (nonatomic) IBOutlet UIButton *revealLeftMenuButton;
@property (nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) IBOutlet UILabel *navigationBarTitleLabel;
@property (nonatomic) IBOutlet UIButton *revealRightMenuButton;
@property (nonatomic) IBOutlet UIView *contentView;

@end


@implementation ContentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showWelcome];
}

- (void)adjustAnchorPointForView:(UIView *)view {
    CGRect frame = view.frame;
    view.layer.anchorPoint = CGPointMake(ContentViewAnchorPointX, view.layer.anchorPoint.y);
    view.frame = frame;
}

- (void)applyMenuTransformations:(CGFloat)percentage forView:(UIView *)view {
    CGFloat angle = percentage * DEGREES_TO_RADIANS(ContentViewMinimumAngle);
    CGFloat translation = percentage * ContentViewMaximumTranslation;
    
    CALayer *layer = view.layer;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = ContentViewM34;
    transform = CATransform3DRotate(transform, angle, 0.0f, 1.0f, 0.0f);
    transform = CATransform3DTranslate(transform, 0.0f, 0.0f, translation);
    layer.transform = transform;
}

- (void)showWelcome {
    WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
    welcomeViewController.didTapStartButtonBlock = ^{
        UIViewController *previousNavigationController = self.currentNavigationController;
        
        [self showExperience];
        
        // re-add welcome view controller
        [self.contentView addSubview:previousNavigationController.view];
        [self addChildViewController:previousNavigationController];
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            previousNavigationController.view.alpha = 0.0f;
            previousNavigationController.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        } completion:^(BOOL finished) {
            [previousNavigationController.view removeFromSuperview];
            [previousNavigationController removeFromParentViewController];
        }];
    };
    
    [self showViewController:welcomeViewController];
}

- (void)showExperience {
    [self showViewController:[[ExperienceViewController alloc] init]];
}

- (void)showResume {
    [self showViewController:[[ResumeViewController alloc] init]];
}

- (void)showHobbies {
    [self showViewController:[[HobbiesViewController alloc] init]];
}

- (void)showAppleBugs {
    [self showViewController:[[IPadBugReport alloc] init]];
}

- (void)showViewController:(UIViewController *)viewController {
    if ([self.currentNavigationController.viewControllers.firstObject isKindOfClass:[viewController class]]) {
        return;// do nothing if requested the same type of view
    }
    
    if (self.currentNavigationController != nil) {
        [self.currentNavigationController.view removeFromSuperview];
        [self.currentNavigationController removeFromParentViewController];
    }
    
    self.currentNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.currentNavigationController.delegate = self;
    self.currentNavigationController.title = self.currentNavigationController.topViewController.title;
    [self.currentNavigationController setNavigationBarHidden:YES];
    
    [self addChildViewController:self.currentNavigationController];
    self.currentNavigationController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.currentNavigationController.view];
    self.navigationBarTitleLabel.text = self.currentNavigationController.title;
}

- (IBAction)didTapRevealLeftMenuButton:(id)sender {
    if (self.didTapRevealLeftMenuButton != NULL) {
        self.didTapRevealLeftMenuButton();
    }
}

- (IBAction)didTapRevealRightMenuButton:(id)sender {
    if (self.didTapRevealRightMenuButton != NULL) {
        self.didTapRevealRightMenuButton();
    }
}

- (IBAction)didTapBackButton:(id)sender {
    [self.currentNavigationController popViewControllerAnimated:YES];
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL shouldShowRevealButton = navigationController.viewControllers.count == 1;
    BOOL shouldShowBackButton = !shouldShowRevealButton;
    self.revealLeftMenuButton.hidden = !shouldShowRevealButton;
    self.backButton.hidden = !shouldShowBackButton;
}

@end
