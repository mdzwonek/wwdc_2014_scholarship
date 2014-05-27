//
//  AbstractViewController.h
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 14/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

@interface AbstractViewController : UIViewController

@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end
