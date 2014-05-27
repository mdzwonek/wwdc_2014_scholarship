//
//  StudiesViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 14/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "StudiesViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface StudiesViewController ()

@property (nonatomic) MPMoviePlayerViewController *moviePlayer;

@end


@implementation StudiesViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"studies";
    }
    return self;
}

- (IBAction)didTapPlayButton:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:@"https://dl.dropboxusercontent.com/u/55836957/Chiron.mp4"];
    self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentViewController:self.moviePlayer animated:YES completion:NULL];
    [self.moviePlayer.moviePlayer play];
}

@end
