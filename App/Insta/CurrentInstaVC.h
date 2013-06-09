//
//  CurrentInstaVC.h
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

//Подробный просмотр инста

#import <UIKit/UIKit.h>

@interface CurrentInstaVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) id currentData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
