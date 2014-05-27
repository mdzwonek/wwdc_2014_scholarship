//
//  ContentViewController.h
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

@interface ContentViewController : UIViewController

@property (nonatomic, copy) void (^didTapRevealLeftMenuButton)();
@property (nonatomic, copy) void (^didTapRevealRightMenuButton)();

- (void)adjustAnchorPointForView:(UIView *)view;

- (void)applyMenuTransformations:(CGFloat)percentage forView:(UIView *)view;

- (void)showWelcome;
- (void)showExperience;
- (void)showResume;
- (void)showHobbies;
- (void)showAppleBugs;

@end
