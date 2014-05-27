//
//  LeftMenuViewController.h
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

@interface LeftMenuViewController : UIViewController

@property (nonatomic, copy) void (^didTapExperienceButtonBlock)();
@property (nonatomic, copy) void (^didTapResumeButtonBlock)();
@property (nonatomic, copy) void (^didTapHobbiesButtonBlock)();
@property (nonatomic, copy) void (^didTapAppleBugsButtonBlock)();

- (void)applyMenuTransformations:(CGFloat)percentage;

@end
