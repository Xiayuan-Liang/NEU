//
//  NewsItem+CoreDataProperties.h
//  iNews
//
//  Created by 梁夏源 on 4/19/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NewsItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSMutableSet<Review *> *reviews;

@end

@interface NewsItem (CoreDataGeneratedAccessors)

- (void)addReviewsObject:(Review *)value;
- (void)removeReviewsObject:(Review *)value;
- (void)addReviews:(NSMutableSet<Review *> *)values;
- (void)removeReviews:(NSMutableSet<Review *> *)values;

@end

NS_ASSUME_NONNULL_END
