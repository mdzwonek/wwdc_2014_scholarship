//
//  AbstractViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 14/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "AbstractViewController.h"
#import "MHFacebookImageViewer.h"


@implementation AbstractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIImageView *imageView in self.imageViews) {
        [imageView setupImageViewer];
    }
    
    self.scrollView.contentSize = self.contentView.frame.size;
}

@end
