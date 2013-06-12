//
//  CurrentInstaVC.m
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

#import "ZAVCurrentInstaVC.h"
#import "AFNetworking.h"
#import "ZAVAppDelegate.h"
#import "LikeAndDislike.h"
#import "Entity.h"

@interface ZAVCurrentInstaVC () 

    @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property (readwrite, nonatomic, strong) UIImageView *profileImage;
    @property (readwrite, nonatomic, strong) UIImageView *generalInstaImage;
    @property (readwrite, nonatomic, strong) UILabel *nameWhoAddedImage;
    @property (readwrite, nonatomic, strong) UILabel *titleInstaName;
    @property (readwrite, nonatomic, strong) UITableView *tableView;
    @property (readwrite, nonatomic, strong) NSArray *likesArr;
    @property (readwrite, nonatomic, strong) UILabel *dateLabel;
    @property (readwrite, nonatomic, strong) UIButton *likeOrDislikeButton;
    @property (readwrite, nonatomic, copy) NSString *identifier;

@end

@implementation ZAVCurrentInstaVC

@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(ZAVAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    
    NSArray *items = [NSArray arrayWithObjects:item1, nil];
    [toolbar setItems:items animated:NO];
    [self.view addSubview:toolbar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    self.tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIView * headerTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 480)];
    
    self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 15, 64, 66)];
    [headerTableView addSubview:self.profileImage];
    
    self.generalInstaImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.profileImage.frame), CGRectGetMaxY(self.profileImage.frame) +5, 306, 306)];
    [headerTableView addSubview:self.generalInstaImage];
    
    self.nameWhoAddedImage = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.profileImage.frame) + 10, 20, 200, 19)];
    self.nameWhoAddedImage.numberOfLines = 1;
    self.nameWhoAddedImage.textColor = [UIColor blueColor];
    self.nameWhoAddedImage.backgroundColor = [UIColor clearColor];
    self.nameWhoAddedImage.textAlignment = NSTextAlignmentLeft;
    [headerTableView addSubview:self.nameWhoAddedImage];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.profileImage.frame) + 10, 50, 250, 19)];
    self.dateLabel.numberOfLines = 1;
    self.dateLabel.textColor = [UIColor blueColor];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    [headerTableView addSubview:self.dateLabel];
    
    self.titleInstaName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.generalInstaImage.frame), CGRectGetMaxY(self.generalInstaImage.frame) + 50, 200, 40)];
    self.titleInstaName.numberOfLines = 10;
    self.titleInstaName.font =[UIFont fontWithName:@"Arial" size:10];
    self.titleInstaName.textColor = [UIColor blueColor];
    self.titleInstaName.backgroundColor = [UIColor clearColor];
    self.titleInstaName.textAlignment = NSTextAlignmentLeft;
    [headerTableView addSubview:self.titleInstaName];
    
    self.likeOrDislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.likeOrDislikeButton addTarget:self
               action:@selector(setLikeOrDislike)
     forControlEvents:UIControlEventTouchDown];
    self.likeOrDislikeButton.frame = CGRectMake(CGRectGetMinX(self.generalInstaImage.frame), CGRectGetMaxY(self.generalInstaImage.frame) + 5, 160.0, 40.0);
    [headerTableView addSubview:self.likeOrDislikeButton];
    
    [self setData];
    
    self.tableView.tableHeaderView = headerTableView;
}

#pragma mark TableViewDeleagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.likesArr.count;
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
    
    cell.textLabel.text = self.likesArr[indexPath.row][@"username"];
    cell.userInteractionEnabled = NO;
    
    return cell;
}


- (void) setData {
    
    if ([_currentData isKindOfClass:[Entity class]]) {
        
        Entity *ent = _currentData;
        self.generalInstaImage.image = [ZAVHelper loadImagewithName:ent.idendifier];
        self.nameWhoAddedImage.text = ent.from;
        self.titleInstaName.text = ent.text;
    
        NSString *str = [NSString stringWithFormat:@"%@", ent.like];
        if ([str isEqualToString:@"1"]) {
            [self.likeOrDislikeButton setTitle:@"Dislike" forState:UIControlStateNormal];
        } else {
            [self.likeOrDislikeButton setTitle:@"Like" forState:UIControlStateNormal];
        }
            self.identifier = ent.idendifier;
    }

    if ([_currentData isKindOfClass:[NSDictionary class]]) {
        
        if ([_currentData[@"likes"] isKindOfClass:[NSDictionary class]]) {
            if ([_currentData[@"likes"][@"data"] isKindOfClass:[NSArray class]]) {
                self.likesArr = _currentData[@"likes"][@"data"];
            }
        }
        
        self.generalInstaImage.image = [ZAVHelper loadImagewithName:self.currentData[@"id"]];
        
        self.identifier = self.currentData[@"id"];
        
        if ([self.currentData[@"user"] isKindOfClass:[NSDictionary class]]) {
            [self.profileImage setImageWithURL:[[NSURL alloc] initWithString:self.currentData[@"user"][@"profile_picture"]] placeholderImage:[UIImage imageNamed:@"Default"]];
            self.nameWhoAddedImage.text = self.currentData[@"user"][@"username"];
        }
        
        if ([_currentData[@"caption"] isKindOfClass:[NSDictionary class]]) {
            self.titleInstaName.text = self.currentData[@"caption"][@"text"];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.currentData[@"created_time"] integerValue]];
        self.dateLabel.text = [NSString stringWithFormat:@"%@", date];

        if (![_currentData[@"user_has_liked"] integerValue] == 0) {
            [self.likeOrDislikeButton setTitle:@"Dislike" forState:UIControlStateNormal];
        } else {
            [self.likeOrDislikeButton setTitle:@"Like" forState:UIControlStateNormal];
        }
    }
}

- (void) close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setLikeOrDislike {
    if ([ZAVHelper connectedToInternet]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults objectForKey:@"AccessToken"];
        
        if ([self.likeOrDislikeButton.titleLabel.text isEqualToString:@"Like"])
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
                
                [self.likeOrDislikeButton setTitle:@"Dislike" forState:UIControlStateNormal];
                
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
                [self.likeOrDislikeButton setTitle:@"Like" forState:UIControlStateNormal];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            [operation start];
        }
    } else {
        
        LikeAndDislike *entityMY = [NSEntityDescription
                            insertNewObjectForEntityForName:@"LikeAndDislike"
                            inManagedObjectContext:self.managedObjectContext];
        
        entityMY.identifier = self.identifier;
        
        if ([self.likeOrDislikeButton.titleLabel.text isEqualToString:@"Like"]) {
            entityMY.like = [NSNumber numberWithBool:YES];
            [self.likeOrDislikeButton setTitle:@"Dislike" forState:UIControlStateNormal];
        } else {
             entityMY.like = [NSNumber numberWithBool:NO];
            [self.likeOrDislikeButton setTitle:@"Like" forState:UIControlStateNormal];
        }

        NSError *error1 = nil;
        if ( ! [[self managedObjectContext] save:&error1]) {
            NSLog(@"An error %@", error1);
        }
    }
}

@end
