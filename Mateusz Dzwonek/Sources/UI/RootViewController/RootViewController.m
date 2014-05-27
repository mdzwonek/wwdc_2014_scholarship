//
//  RootViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "RootViewController.h"
#import <MDSDK/MDSDK.h>
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "ContentViewController.h"


static const CGFloat RightMenuMinScale = 0.8f;


@interface RootViewController ()

@property (nonatomic) MDAnimatedDotsViewController *animatedDotsVC;

@property (nonatomic) LeftMenuViewController *leftMenuVC;
@property (nonatomic) RightMenuViewController *rightMenuVC;
@property (nonatomic) ContentViewController *contentVC;
@property (nonatomic) MDSideMenuViewController *sideMenuVC;

@property (nonatomic) UIView *blurView;

@end


@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 3.0f;
    
    [self initializeDotsViewController];
    [self initializeAllViewsAnimated:NO];
}

- (void)initializeAllViewsAnimated:(BOOL)animated {
    [self initializeLeftMenuVC];
    [self initializeRightMenuVC];
    [self initializeContentVC];
    [self initializeSideMenuVC];
    
    if (animated) {
        self.sideMenuVC.view.alpha = 0.0f;
        [UIView animateWithDuration:1.0 animations:^{
            self.sideMenuVC.view.alpha = 1.0f;
        }];
    }
}

- (void)initializeDotsViewController {
    self.animatedDotsVC = [[MDAnimatedDotsViewController alloc] init];
    
    self.animatedDotsVC.dotsScene.backgroundImage = ^UIImage *{
        return [UIImage imageNamed:@"background"];
    };
    self.animatedDotsVC.dotsScene.colorForDotNode = ^UIColor *(MDDotNode *dotNode) {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    };
    
    [self addChildViewController:self.animatedDotsVC];
    self.animatedDotsVC.view.frame = self.view.frame;
    [self.view addSubview:self.animatedDotsVC.view];
}

- (void)initializeLeftMenuVC {
    self.leftMenuVC = [[LeftMenuViewController alloc] init];
    
    __weak RootViewController *weakSelf = self;
    
    self.leftMenuVC.didTapExperienceButtonBlock = ^{
        [weakSelf.sideMenuVC hideLeftMenu];
        [weakSelf.contentVC showExperience];
    };
    self.leftMenuVC.didTapResumeButtonBlock = ^{
        [weakSelf.sideMenuVC hideLeftMenu];
        [weakSelf.contentVC showResume];
    };
    self.leftMenuVC.didTapHobbiesButtonBlock = ^{
        [weakSelf.sideMenuVC hideLeftMenu];
        [weakSelf.contentVC showHobbies];
    };
    self.leftMenuVC.didTapAppleBugsButtonBlock = ^{
        [weakSelf.sideMenuVC hideLeftMenu];
        [weakSelf.contentVC showAppleBugs];
    };
}

- (void)initializeRightMenuVC {
    self.rightMenuVC = [[RightMenuViewController alloc] init];
}

- (void)initializeContentVC {
    self.contentVC = [[ContentViewController alloc] init];
    
    __weak RootViewController *weakSelf = self;
    
    self.contentVC.didTapRevealLeftMenuButton = ^{
        [weakSelf.sideMenuVC showLeftMenu];
    };
    self.contentVC.didTapRevealRightMenuButton = ^{
        [weakSelf.sideMenuVC showRightMenu];
    };
}

- (void)initializeSideMenuVC {
    self.sideMenuVC = [[MDSideMenuViewController alloc] initWithLeftMenuVC:self.leftMenuVC rightMenuVC:self.rightMenuVC andContentVC:self.contentVC];
    [self addChildViewController:self.sideMenuVC];
    self.sideMenuVC.view.frame = self.view.bounds;
    [self.view addSubview:self.sideMenuVC.view];
    
    [self.contentVC adjustAnchorPointForView:self.sideMenuVC.contentView];
    
    __weak RootViewController *weakSelf = self;
    
    typedef void(^MenuTransormations)(MDSideMenuViewController *sideMenuVC, UIView *menu, CGFloat percentage, BOOL willBeVisible);
    MenuTransormations originalMenuTransormations = self.sideMenuVC.applyMenuTransformations;
    self.sideMenuVC.applyMenuTransformations = ^(MDSideMenuViewController *sideMenuVC, UIView *menu, CGFloat percentage, BOOL willBeVisible) {
        [weakSelf.animatedDotsVC start];// start animated dots when a menu is about to start
        if (menu == weakSelf.sideMenuVC.leftMenuView) {
            [weakSelf.contentVC applyMenuTransformations:percentage forView:weakSelf.sideMenuVC.contentView];
            [weakSelf.leftMenuVC applyMenuTransformations:percentage];
        } else {
            originalMenuTransormations(sideMenuVC, menu, percentage, willBeVisible);
        }
    };
    
    self.sideMenuVC.didToggleLeftMenuBlock = ^(MDSideMenuViewController *sideMenuVC) {
        if (sideMenuVC.leftMenuHidden) {
            [weakSelf.animatedDotsVC stop];
        }
    };
    
    self.sideMenuVC.didToggleRightMenuBlock = ^(MDSideMenuViewController *sideMenuVC) {
        if (sideMenuVC.rightMenuHidden) {
            [weakSelf.animatedDotsVC stop];
        }
    };
    
    self.sideMenuVC.minMenuScale = RightMenuMinScale;
}

- (void)fadeOutWithDuration:(NSTimeInterval)duration {
    UIWindow *window = self.view.window;
    
    UIToolbar *blurToolbar = [[UIToolbar alloc] initWithFrame:window.bounds];
    blurToolbar.barStyle = UIBarStyleBlack;
    [window addSubview:blurToolbar];
    
    self.blurView = blurToolbar;
    self.blurView.alpha = 0.0f;
    
    __block BOOL isAnimating = YES;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
        self.blurView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        isAnimating = NO;
    }];
}

- (void)fadeInWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.blurView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.blurView removeFromSuperview];
        self.blurView = nil;
    }];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
