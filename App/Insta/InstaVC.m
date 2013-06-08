//
//  InstaVC.m
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

#import "InstaVC.h"
#import "AFNetworking.h"

@interface InstaVC () {
    
    NSMutableArray *data;
    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicatorView;
}

@end

@implementation InstaVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    data = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //Создание ячейки
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = data[indexPath.row][@"created_time"];
    
    NSURL *url = [[NSURL alloc] initWithString:data[indexPath.row][@"images"][@"low_resolution"][@"url"]];
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
    
    return cell;
}

- (void)getData {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"AccessToken"];

    NSString *urlString =[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@", token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        data = [JSON objectForKey:@"data"];
        [_activityIndicatorView stopAnimating];
        [_tableView setHidden:NO];
        [_tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
}


@end
