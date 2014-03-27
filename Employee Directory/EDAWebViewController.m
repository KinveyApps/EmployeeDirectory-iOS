//
//  EDAWebViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAWebViewController.h"

@interface EDAWebViewController () <UIWebViewDelegate>

@property (nonatomic) NSURL *URL;
@property (nonatomic) UIWebView *view;

@end

@implementation EDAWebViewController

- (id)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _URL = URL;
        RACSignal *shouldLoadSignal = [[[self rac_signalForSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:) fromProtocol:@protocol(UIWebViewDelegate)]
            reduceEach:^NSURL *(UIWebView *webView, NSURLRequest *request, NSNumber *navigationType){
                return request.URL;
            }]
            filter:^BOOL(NSURL *aURL) {
                BOOL equal = [URL.absoluteString isEqual:aURL.absoluteString];
                return equal == NO;
            }];
        RACSignal *errorSignal = [[[self rac_signalForSelector:@selector(webView:didFailLoadWithError:) fromProtocol:@protocol(UIWebViewDelegate)]
            reduceEach:^NSError *(UIWebView *webView, NSError *error){
                return error;
            }]
            flattenMap:^RACStream *(NSError *error) {
                return [RACSignal error:error];
            }];
        
        _shouldLoadURLSignal = [RACSignal merge:@[ shouldLoadSignal ]];
    }
    return self;
}

- (void)loadView {
    self.view = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.delegate = self;
    [self.view loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

#pragma mark - UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
