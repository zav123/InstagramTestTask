//
//  LoginVC.m
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

//authorization Insta

#import "LoginVC.h"

#define AuthorizationLink @"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code"
#define Cliant_ID @"324b9a0a3d044e109270bbad54f68ac3"
#define Redirect_uri @"http://easydevios.blogspot.ru/123"


@interface LoginVC () {
    
    UIWebView *_webView;
}

@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:AuthorizationLink, Cliant_ID, Redirect_uri]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    _webView.delegate = self;
    
    [self.view addSubview:_webView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([_webView.request.URL.absoluteString rangeOfString:@"code="].location != NSNotFound) {
        NSArray *fierstPart = [[[[webView request] URL] absoluteString] componentsSeparatedByString:@"code="];
        NSString *fierstPatsStr = [fierstPart lastObject];
        NSArray *secondArr = [fierstPatsStr componentsSeparatedByString:@"&"];
        
        if (secondArr.count > 0) {
            NSString *token = secondArr[0];
            
            if(token){
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"AccessToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}


@end
