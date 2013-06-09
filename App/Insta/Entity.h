//
//  Entity.h
//  Insta
//
//  Created by admin on 09.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

//класс для модели БД

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * idendifier;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSData * image;

@end
