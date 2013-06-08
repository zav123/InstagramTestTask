//
//  InstaVC.m
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

#import "InstaVC.h"
#import "AFNetworking.h"
#import "LoginVC.h"

@interface InstaVC () {
    
    NSMutableArray *data;
    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicatorView;
    NSString *nextPage;
}

@end

@implementation InstaVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    data = [[NSMutableArray alloc] init];
    nextPage = [[NSString alloc] init];
    
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
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    _activityIndicatorView.center = self.view.center;
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    [self getData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.row +1 == data.count) {
        [self getData];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //Создание ячейки
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = data[indexPath.row][@"created_time"];
    
    NSURL *url = [[NSURL alloc] initWithString:data[indexPath.row][@"images"][@"low_resolution"][@"url"]];
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Default"]];
    
    return cell;
}

- (void)getData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"AccessToken"];
    
    NSString *urlString;
    if (data.count > 0) {
        urlString = nextPage;
    } else {
        urlString =[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?count=20&access_token=%@", token];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [data addObjectsFromArray:[JSON objectForKey:@"data"]];
        
        nextPage =  [JSON objectForKey:@"pagination"][@"next_url"];
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


@end
