//
//  Review+CoreDataProperties.h
//  iNews
//
//  Created by 梁夏源 on 4/19/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface Review (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *reviewDetail;
@property (nullable, nonatomic, retain) User *user;
@property (nullable, nonatomic, retain) NewsItem *newsItem;

@end

NS_ASSUME_NONNULL_END
