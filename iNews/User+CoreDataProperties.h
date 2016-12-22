//
//  User+CoreDataProperties.h
//  iNews
//
//  Created by 梁夏源 on 4/19/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSData *icon;
@property (nullable, nonatomic, retain) NSMutableSet<Review *> *reviews;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addReviewsObject:(Review *)value;
- (void)removeReviewsObject:(Review *)value;
- (void)addReviews:(NSMutableSet<Review *> *)values;
- (void)removeReviews:(NSMutableSet<Review *> *)values;

@end

NS_ASSUME_NONNULL_END
