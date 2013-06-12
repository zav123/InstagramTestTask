//
//  Entity.h
//  Insta
//
//  Created by admin on 10.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * idendifier;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * like;

@end
