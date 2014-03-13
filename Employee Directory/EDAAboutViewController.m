//
//  EDAAboutViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAAboutViewController.h"

@interface EDAAboutViewController ()

@property (nonatomic) UIWebView *view;

@end

@implementation EDAAboutViewController

- (void)loadView {
    self.view = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"About";
    
    [self.view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://kinvey.com"]]];
}

@end
