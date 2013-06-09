//
//  InstaVC.h
//  Insta
//
//  Created by admin on 08.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

//табличное представление набора инстов

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface InstaVC : UIViewController <UITableViewDataSource, UITableViewDelegate, PullToRefreshViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
