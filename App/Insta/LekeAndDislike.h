//
//  LekeAndDislike.h
//  Insta
//
//  Created by admin on 09.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LekeAndDislike : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * like;

@end
