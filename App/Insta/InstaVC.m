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
#import "ZAVAppDelegate.h"
#import "Entity.h"
#import "CurrentInstaVC.h"
#import "LekeAndDislike.h"

@interface InstaVC () {
    
    PullToRefreshView *pull;
    NSMutableArray *dataArrayWithInsta;
    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicatorView;
    NSString *nextPageURL;
}

@end

@implementation InstaVC

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(ZAVAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    [self checkNotSendLikeOrDislike];
    
    dataArrayWithInsta = [[NSMutableArray alloc] init];
    nextPageURL = [[NSString alloc] init];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStyleBordered target:self action:@selector(signOut)];
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTableData)];
    NSArray *items = [NSArray arrayWithObjects:item1, flexiableItem, item2, nil];
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
    
    int indexMy = indexPath.row;
    //если добрались до предпоследней ячейки, грузим еще данные
    if (indexMy +2 == dataArrayWithInsta.count) {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    CurrentInstaVC *vc = [[CurrentInstaVC alloc] init];
    vc.currentData = dataArrayWithInsta[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)getDataArrayWithInsta {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"AccessToken"];
    
    if (![self connectedToInternet]) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            
        }
        [dataArrayWithInsta addObjectsFromArray:fetchedObjects];
        
        [_activityIndicatorView stopAnimating];
        [_tableView setHidden:NO];
        [_tableView reloadData];
     
    } else {
        NSFetchRequest * allEntytis = [[NSFetchRequest alloc] init];
        [allEntytis setEntity:[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:_managedObjectContext]];
        [allEntytis setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * entitys = [_managedObjectContext executeFetchRequest:allEntytis error:&error];
        //error handling goes here
        for (NSManagedObject * ent in entitys) {
            [_managedObjectContext deleteObject:ent];
        }
        NSError *saveError = nil;
        [_managedObjectContext save:&saveError];
        
        NSString *urlString;
        if (dataArrayWithInsta.count > 0 && ![dataArrayWithInsta[0] isKindOfClass:[Entity class]]) {
            urlString = nextPageURL;
        } else {
            urlString =[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?count=20&access_token=%@", token];
        }
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            for (id object in [JSON objectForKey:@"data"]) {
                
                Entity *entityMY = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Entity"
                                    inManagedObjectContext:self.managedObjectContext];
                
                entityMY.from = [object objectForKey:@"user"][@"username"];
                entityMY.idendifier = object[@"id"];
                                
                if ([object objectForKey:@"user_has_liked"] == [NSNumber numberWithBool:YES]) {
                    entityMY.like = [NSNumber numberWithBool:YES];
                } else {
                    entityMY.like = [NSNumber numberWithBool:NO];
                }
                
                if ([object[@"caption"] isKindOfClass:[NSDictionary class]]) {
                    entityMY.text = object[@"caption"][@"text"];
                }
                
                NSError *error1 = nil;
                if ( ! [[self managedObjectContext] save:&error1]) {
                    NSLog(@"An error %@", error1);
                }
                
            }
            if ([JSON objectForKey:@"data"]) {
                [dataArrayWithInsta addObjectsFromArray:[JSON objectForKey:@"data"]];
                nextPageURL =  [JSON objectForKey:@"pagination"][@"next_url"];
            }

            [_activityIndicatorView stopAnimating];
            [_tableView setHidden:NO];
            [_tableView reloadData];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
       
        }];
        
        [operation start];
        
    }
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
    if ([self connectedToInternet]) {
        [self checkNotSendLikeOrDislike];
        [_activityIndicatorView startAnimating];
        [dataArrayWithInsta removeAllObjects];
        [self getDataArrayWithInsta];
        [_tableView reloadData];
    }
    [pull finishedLoading];
        
}

- (BOOL)connectedToInternet
{
    NSURL *url=[NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode]==200)?YES:NO;
}

- (void) checkNotSendLikeOrDislike {
    
    if ([self connectedToInternet]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LekeAndDislike" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count > 0) {
            
            for (LekeAndDislike *object in fetchedObjects) {
                NSString *str = [NSString stringWithFormat:@"%@", object.like];
                if ([str isEqualToString:@"0"]) {
                    [self sendDislikewithidentifier:object.identifier];
                } else {
                    [self sendLikewithIdentifier:object.identifier];
                }
            }
            [fetchRequest setIncludesPropertyValues:NO]; 
            
            NSError * error = nil;
            NSArray * entitys = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
            //error handling goes here
            for (NSManagedObject *ent in entitys) {
                [_managedObjectContext deleteObject:ent];
            }
            NSError *saveError = nil;
            [_managedObjectContext save:&saveError];
        }
        
    }
}

- (void)sendLikewithIdentifier:(NSString *)identifier {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"AccessToken"];
    
    NSString *tempUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", identifier];
    NSURL *url = [NSURL URLWithString:tempUrl];
    
    AFHTTPClient *aClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [aClient setParameterEncoding:AFFormURLParameterEncoding];
    
    NSMutableURLRequest *request = [aClient requestWithMethod:@"POST"
                                                         path:tempUrl
                                                   parameters:@{@"access_token": token}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [aClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
  
}

- (void)sendDislikewithidentifier:(NSString *)identifier {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"AccessToken"];
    
    NSString *tempUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", identifier];
    NSURL *url = [NSURL URLWithString:tempUrl];
    
    AFHTTPClient *aClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [aClient setParameterEncoding:AFFormURLParameterEncoding];
    
    NSMutableURLRequest *request = [aClient requestWithMethod:@"DELETE"
                                                         path:tempUrl
                                                   parameters:@{@"access_token": token}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [aClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}


@end
