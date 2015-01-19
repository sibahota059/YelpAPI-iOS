//
//  SPHWebViewController.m
//  ChupaChat
//
//  Created by Heart on 26/05/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import "SPHWebViewController.h"

@interface SPHWebViewController ()

@end

@implementation SPHWebViewController
@synthesize type,mobileUrl;
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
    [self setupHeader];
    [super viewDidLoad];
    
    self.WebView.scrollView.bounces=NO;
    [self.WebView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.WebView.scrollView setShowsVerticalScrollIndicator:NO];
     self.WebView.scalesPageToFit=YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)showaddress:(NSURL *)urlstring
{
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlstring];
  [ self.WebView loadRequest:requestObj];
}



-(IBAction) gowebBack:(id)sender
{
    [self.WebView goBack];
}


-(IBAction) goForward:(id)sender
{
    [self.WebView goForward];
}

- (IBAction)reloAdPage:(id)sender {
    [self setupHeader];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.WebView.alpha=1.0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.WebView.alpha=1.0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}




-(void)setupHeader
{
    self.WebView.alpha=0.0;
   [self showaddress:[NSURL URLWithString:mobileUrl]];}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
