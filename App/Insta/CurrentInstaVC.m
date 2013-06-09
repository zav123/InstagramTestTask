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
}

@end

@implementation CurrentInstaVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 64, 66)];
    [self.view addSubview:profileImage];
    
    generalInstaImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(profileImage.frame), CGRectGetMaxY(profileImage.frame) +5, 306, 306)];
    [self.view addSubview:generalInstaImage];
    
    nameWhoAddedImage = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImage.frame) + 10, 25, 200, 15)];
    nameWhoAddedImage.numberOfLines = 1;
    nameWhoAddedImage.textColor = [UIColor blueColor];
    nameWhoAddedImage.backgroundColor = [UIColor clearColor];
    nameWhoAddedImage.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nameWhoAddedImage];
    
    titleInstaName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(generalInstaImage.frame), CGRectGetMaxY(generalInstaImage.frame), 200, 40)];
    titleInstaName.numberOfLines = 10;
    titleInstaName.font =[UIFont fontWithName:@"Arial" size:8];
    titleInstaName.textColor = [UIColor blueColor];
    titleInstaName.backgroundColor = [UIColor clearColor];
    titleInstaName.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleInstaName];
}

- (void) setData {
    
    if ([_currentData isKindOfClass:[NSDictionary class]]) {
        if ([_currentData[@"images"] isKindOfClass:[NSDictionary class]]) {
            if ([_currentData[@"images"][@"low_resolution"] isKindOfClass:[NSDictionary class]]) {
                [generalInstaImage setImageWithURL:[[NSURL alloc] initWithString:_currentData[@"images"][@"low_resolution"][@"url"]] placeholderImage:[UIImage imageNamed:@"Default"]];
            }
        }
        
        if ([_currentData[@"user"] isKindOfClass:[NSDictionary class]]) {
            [profileImage setImageWithURL:[[NSURL alloc] initWithString:_currentData[@"user"][@"profile_picture"]] placeholderImage:[UIImage imageNamed:@"Default"]];
            nameWhoAddedImage.text = _currentData[@"user"][@"username"];
        }
        
        if ([_currentData[@"caption"] isKindOfClass:[NSDictionary class]]) {
            titleInstaName.text = _currentData[@"caption"][@"text"];
        }
    }
}



@end
