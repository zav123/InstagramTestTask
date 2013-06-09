//
//  CurrentInstaVC.m
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

#import "CurrentInstaVC.h"
#import "AFNetworking.h"

@interface CurrentInstaVC () {
    
    UIImageView *profileImage;
    UIImageView *generalInstaImage;
    UILabel *nameWhoAddedImage;
    UILabel *titleInstaName;
    UITableView *_tableView;
    NSArray *likesArr;
    UILabel *dateLabel;
    UIButton *likeOrDislikeButton;
    
}

@end

@implementation CurrentInstaVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    
    NSArray *items = [NSArray arrayWithObjects:item1, nil];
    [toolbar setItems:items animated:NO];
    [self.view addSubview:toolbar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView * headerTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 480)];
    
    profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 15, 64, 66)];
    [headerTableView addSubview:profileImage];
    
    generalInstaImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(profileImage.frame), CGRectGetMaxY(profileImage.frame) +5, 306, 306)];
    [headerTableView addSubview:generalInstaImage];
    
    nameWhoAddedImage = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImage.frame) + 10, 20, 200, 19)];
    nameWhoAddedImage.numberOfLines = 1;
    nameWhoAddedImage.textColor = [UIColor blueColor];
    nameWhoAddedImage.backgroundColor = [UIColor clearColor];
    nameWhoAddedImage.textAlignment = NSTextAlignmentLeft;
    [headerTableView addSubview:nameWhoAddedImage];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImage.frame) + 10, 50, 250, 19)];
    dateLabel.numberOfLines = 1;
    dateLabel.textColor = [UIColor blueColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [headerTableView addSubview:dateLabel];
    
    titleInstaName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(generalInstaImage.frame), CGRectGetMaxY(generalInstaImage.frame) + 40, 200, 40)];
    titleInstaName.numberOfLines = 10;
    titleInstaName.font =[UIFont fontWithName:@"Arial" size:8];
    titleInstaName.textColor = [UIColor blueColor];
    titleInstaName.backgroundColor = [UIColor clearColor];
    titleInstaName.textAlignment = NSTextAlignmentLeft;
    [headerTableView addSubview:titleInstaName];
    
    if ([_currentData[@"likes"] isKindOfClass:[NSDictionary class]]) {
        if ([_currentData[@"likes"][@"data"] isKindOfClass:[NSArray class]]) {
            likesArr = _currentData[@"likes"][@"data"];
        }
    }
    
    likeOrDislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [likeOrDislikeButton addTarget:self
               action:@selector(setLikeOrDislike)
     forControlEvents:UIControlEventTouchDown];
    [likeOrDislikeButton setTitle:@"Show View" forState:UIControlStateNormal];
    likeOrDislikeButton.frame = CGRectMake(CGRectGetMinX(generalInstaImage.frame), CGRectGetMaxY(generalInstaImage.frame) + 5, 160.0, 40.0);
    [headerTableView addSubview:likeOrDislikeButton];
    
    [self setData];
    
    _tableView.tableHeaderView = headerTableView;
}

#pragma mark TableViewDeleagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return likesArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 25.0;
}

#pragma mark DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = likesArr[indexPath.row][@"username"];
    cell.userInteractionEnabled = NO;
    
    return cell;
}


- (void) setData {
    
    if ([_currentData isKindOfClass:[NSDictionary class]]) {
        
        generalInstaImage.image = [self loadImagewithName:_currentData[@"id"]];
        
        if ([_currentData[@"user"] isKindOfClass:[NSDictionary class]]) {
            [profileImage setImageWithURL:[[NSURL alloc] initWithString:_currentData[@"user"][@"profile_picture"]] placeholderImage:[UIImage imageNamed:@"Default"]];
            nameWhoAddedImage.text = _currentData[@"user"][@"username"];
        }
        
        if ([_currentData[@"caption"] isKindOfClass:[NSDictionary class]]) {
            titleInstaName.text = _currentData[@"caption"][@"text"];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_currentData[@"created_time"] integerValue]];
        dateLabel.text = [NSString stringWithFormat:@"%@", date];

        if (![_currentData[@"user_has_liked"] integerValue] == 0) {
            [likeOrDislikeButton setTitle:@"Dislike" forState:UIControlStateNormal];
        } else {
            [likeOrDislikeButton setTitle:@"Like" forState:UIControlStateNormal];
        }
    }
}

- (void) close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*)loadImagewithName:(NSString *)nameImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      nameImage];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

- (void)setLikeOrDislike {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"AccessToken"];
    
    if ([likeOrDislikeButton.titleLabel.text isEqualToString:@"Like"])
    {
        NSString *tempUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", _currentData[@"id"]];
        NSURL *url = [NSURL URLWithString:tempUrl];
        
        AFHTTPClient *aClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [aClient setParameterEncoding:AFFormURLParameterEncoding];
        
        NSMutableURLRequest *request = [aClient requestWithMethod:@"POST"
                                                             path:tempUrl
                                                       parameters:@{@"access_token": token}];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [aClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [likeOrDislikeButton setTitle:@"Dislike" forState:UIControlStateNormal];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operation start];
    } else {
        NSString *tempUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", _currentData[@"id"]];
        NSURL *url = [NSURL URLWithString:tempUrl];
        
        AFHTTPClient *aClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [aClient setParameterEncoding:AFFormURLParameterEncoding];
        
        NSMutableURLRequest *request = [aClient requestWithMethod:@"DELETE"
                                                             path:tempUrl
                                                       parameters:@{@"access_token": token}];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [aClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [likeOrDislikeButton setTitle:@"Like" forState:UIControlStateNormal];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operation start];
    }
}

@end
