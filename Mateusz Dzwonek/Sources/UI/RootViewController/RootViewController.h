//
//  RootViewController.h
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

@interface RootViewController : UIViewController

- (void)initializeAllViewsAnimated:(BOOL)animated;

- (void)fadeOutWithDuration:(NSTimeInterval)duration;
- (void)fadeInWithDuration:(NSTimeInterval)duration;

@end
