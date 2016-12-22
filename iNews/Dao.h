//
//  Dao.h
//  
//
//  Created by 梁夏源 on 4/19/16.
//
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "User.h"
#import "NewsItem.h"
#import "Review.h"
@interface Dao : NSObject
{
    NSManagedObjectContext *managedObjectContext;
}

//custom initializer
-(id)initWithDelegate;
-(User *)authenticateUser:(NSString *)email withPassword:(NSString *)password;
-(BOOL)retriveUsers:(NSString *)email;
-(BOOL)createUser:(NSString *)email withPassword:(NSString *)password;
-(void)modifiyUser:(NSString *)email withName:(NSString *)username andIcon:(NSData *)icon;

-(Review *)createReview:(NSString *)comment inUser:(User *)user andNewsItem:(NewsItem *)newsItem;
-(NewsItem *)createNewsItem:(NSString *)url;

-(void)setReviewToUser:(User *)user withReview:(Review *)review;
-(void)setReviewToNewsItem:(NewsItem *)newsItem withReview:(Review *)review;
-(NewsItem *)retriveItems:(NSString *)urlString;
@end
