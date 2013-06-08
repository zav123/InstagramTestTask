//
//  ListInstaCell.m
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

#import "ListInstaCell.h"
#import "AFNetworking.h"

@implementation ListInstaCell {
    UIImageView *profileImage;
    UIImageView *generalInstaImage;
    UILabel *nameWhoAddedImage;
    UILabel *titleInstaName;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 64, 66)];
        [self.contentView addSubview:profileImage];
        
        generalInstaImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(profileImage.frame), CGRectGetMaxY(profileImage.frame) +5, 306, 306)];
        [self.contentView addSubview:generalInstaImage];
        
        nameWhoAddedImage = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImage.frame) + 10, 25, 200, 15)];
        nameWhoAddedImage.numberOfLines = 1;
        nameWhoAddedImage.textColor = [UIColor blueColor];
        nameWhoAddedImage.backgroundColor = [UIColor clearColor];
        nameWhoAddedImage.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameWhoAddedImage];
        
        titleInstaName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(generalInstaImage.frame), CGRectGetMaxY(generalInstaImage.frame), 200, 40)];
        titleInstaName.numberOfLines = 10;
        titleInstaName.font =[UIFont fontWithName:@"Arial" size:8];
        titleInstaName.textColor = [UIColor blueColor];
        titleInstaName.backgroundColor = [UIColor clearColor];
        titleInstaName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleInstaName];
    }
    return self;
}

- (void)setDataInCellWithCurrentElement:(NSDictionary *)data {
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([data[@"images"] isKindOfClass:[NSDictionary class]]) {
            if ([data[@"images"][@"low_resolution"] isKindOfClass:[NSDictionary class]]) {
                [generalInstaImage setImageWithURL:[[NSURL alloc] initWithString:data[@"images"][@"low_resolution"][@"url"]] placeholderImage:[UIImage imageNamed:@"Default"]];
            }
        }
        
        if ([data[@"user"] isKindOfClass:[NSDictionary class]]) {
            [profileImage setImageWithURL:[[NSURL alloc] initWithString:data[@"user"][@"profile_picture"]] placeholderImage:[UIImage imageNamed:@"Default"]];
            nameWhoAddedImage.text = data[@"user"][@"username"];
        }
        
        if ([data[@"caption"] isKindOfClass:[NSDictionary class]]) {
         titleInstaName.text = data[@"caption"][@"text"];
        }
    }
}

@end
