//
//  InstaVC.m
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

//Класс отображения перечня фото

#import "InstaVC.h"
#import "AFNetworking.h"
#import "LoginVC.h"
#import "PullToRefreshView.h"
#import "ListInstaCell.h"

@interface InstaVC () {
    
    PullToRefreshView *pull;
    NSMutableArray *dataArrayWithInsta;
    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicatorView;
    NSString *nextPageURL;
}

@end

@implementation InstaVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataArrayWithInsta = [[NSMutableArray alloc] init];
    nextPageURL = [[NSString alloc] init];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStyleBordered target:self action:@selector(signOut)];
    NSArray *items = [NSArray arrayWithObjects:item1, nil];
    [toolbar setItems:items animated:NO];
    [self.view addSubview:toolbar];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) _tableView];
    [pull setDelegate:self];
    [_tableView addSubview:pull];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    _activityIndicatorView.center = self.view.center;
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    [self getDataArrayWithInsta];
}

#pragma mark TableViewDeleagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArrayWithInsta.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 450.0;
}

#pragma mark DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.row +1 == dataArrayWithInsta.count) {
        [_activityIndicatorView startAnimating];
        [self getDataArrayWithInsta];
    }
    
    ListInstaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ListInstaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setDataInCellWithCurrentElement:dataArrayWithInsta[indexPath.row]];
  
    return cell;
}

- (void)getDataArrayWithInsta {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"AccessToken"];
    
    NSString *urlString;
    if (dataArrayWithInsta.count > 0) {
        urlString = nextPageURL;
    } else {
        urlString =[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?count=20&access_token=%@", token];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [dataArrayWithInsta addObjectsFromArray:[JSON objectForKey:@"data"]];
        
        nextPageURL =  [JSON objectForKey:@"pagination"][@"next_url"];
        [_activityIndicatorView stopAnimating];
        [_tableView setHidden:NO];
        [_tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
}

- (void)signOut {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"AccessToken"];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [userDefaults synchronize];
    
    LoginVC *vc = [[LoginVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark PullDalagate

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self reloadTableData];
}

- (void) reloadTableData
{
    [_activityIndicatorView startAnimating];
    [dataArrayWithInsta removeAllObjects];
    [self getDataArrayWithInsta];
    [_tableView reloadData];
    [pull finishedLoading];
}
@end
