//
//  LoginVC.m
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

//authorization Insta

#import "LoginVC.h"
#import "InstaVC.h"

#define AuthorizationLink @"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token"
#define Cliant_ID @"8cdc54227130438f9232c710e74d9258"
#define Redirect_uri @"http://localhost:8888/MAMP/"


@interface LoginVC () {
    
    UIWebView *_webView;
}

@end

@implementation LoginVC


- (void)viewDidLoad
{
    [super viewDidLoad];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *fullURL = [NSString stringWithFormat:AuthorizationLink, Cliant_ID, Redirect_uri];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString* urlString = [[request URL] absoluteString];
    NSURL *Url = [request URL];
    NSArray *UrlParts = [Url pathComponents];
    if ([[UrlParts objectAtIndex:(1)] isEqualToString:@"MAMP"]) {
        NSRange tokenParam = [urlString rangeOfString: @"access_token="];
        if (tokenParam.location != NSNotFound) {
            NSString* token = [urlString substringFromIndex: NSMaxRange(tokenParam)];

            NSRange endRange = [token rangeOfString: @"&"];
            if (endRange.location != NSNotFound)
                token = [token substringToIndex: endRange.location];
            
            NSLog(@"access token %@", token);
            if ([token length] > 0 ) {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"AccessToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                InstaVC *vc = [[InstaVC alloc] init];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        return NO;
    }
    return YES;
}




@end
