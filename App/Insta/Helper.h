//
//  Helper.h
//  Insta
//
//  Created by admin on 10.06.13.
//  Copyright (c) 2013 zav333. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface Helper : NSObject

+ (BOOL)connectedToInternet;
+ (void)saveImage: (UIImage*)image withName:(NSString *)nameImage;
+ (UIImage*)loadImagewithName:(NSString *)nameImage;

@end
