//
//  WebViewController.m
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "FFAWebViewController.h"


#define DEFAULT_URL @"http://www.apple.com/"

@implementation FFAWebViewController

@synthesize webView;
@synthesize backButton;
@synthesize forwardButton;
@synthesize stopButton;
@synthesize refreshButton;
@synthesize activityIndicator;


#pragma mark - config nav button state

- (void)configureNavButtons
{
    [self.stopButton setEnabled:[self.webView isLoading]];
    [self.refreshButton setEnabled:![self.webView isLoading]];
    [self.backButton setEnabled:[self.webView canGoBack]];
    [self.forwardButton setEnabled:[self.webView canGoForward]];
}


#pragma mark - webviewdelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    [self configureNavButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error loading...");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"loading web content...");
    [self configureNavButtons];
}


#pragma mark - navigation

- (void)stopLoading
{
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
}

- (IBAction)goForward:(id)sender
{
    [self stopLoading];
    [self.webView goForward];
}

- (IBAction)goBack:(id)sender
{
    [self stopLoading];
    [self.webView goBack];
}

- (IBAction)refresh:(id)sender
{
    [self stopLoading];
    [self.webView reload];
}

- (IBAction)stop:(id)sender
{
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
        [self configureNavButtons];
    }
}


#pragma mark - lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DEFAULT_URL]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
