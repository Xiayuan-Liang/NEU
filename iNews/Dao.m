//
//  Dao.m
//  
//
//  Created by 梁夏源 on 4/19/16.
//
//

#import "Dao.h"

@implementation Dao

-(id)initWithDelegate{
    self = [super init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    return self;
}

-(User *)authenticateUser:(NSString *)email withPassword:(NSString *)password{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext: managedObjectContext];
    [request setEntity:user];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        return nil; //DB record is nil
    }else{
        for(User *user in mutableFetchResults){
            if ([user.email isEqualToString:email] &&[user.password isEqualToString:password]) {
                return user;
            }
        }
      return nil;
    }
    
}

-(BOOL)retriveUsers:(NSString *)email{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext: managedObjectContext];
    [request setEntity:user];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    NSLog(@"user count = %lu", (unsigned long)mutableFetchResults.count);
    if (mutableFetchResults == nil) {
         NSLog(@"first user");
        return false; //register the first user
    }else{
        for(User *user in mutableFetchResults){
            if ([user.email isEqualToString:email]) {
                return true; //user exists
            }
        }
    }

    return false; //user not exist
}

-(BOOL)createUser:(NSString *)email withPassword:(NSString *)password{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
    [user setEmail:email];
    [user setPassword:password];
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]){
        //handle error
        NSLog(@"insert error");
        return false;
    }else{
        return true;
    }
}

-(void)modifiyUser:(NSString *)email withName:(NSString *)username andIcon:(NSData *)icon
{

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext: managedObjectContext];
    [request setEntity:user];
    
   // request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
     //select * from User where email = %@
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", email];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *userArray = [managedObjectContext executeFetchRequest:request error:&error];
    if(userArray) {
        User *u = [userArray objectAtIndex:0];
        u.username = username;
        u.icon = icon;
        [managedObjectContext save:&error];
    } else {
        NSLog(@"Error: %@", error);
    }
}

-(NewsItem *)createNewsItem:(NSString *)url
{
    NewsItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItem" inManagedObjectContext:managedObjectContext];

    [item setUrl:url];
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]){
        //handle error
        NSLog(@"insert error");
        return nil;
    }else{
        return item;
    }
}

-(Review *)createReview:(NSString *)comment inUser:(User *)user andNewsItem:(NewsItem *)newsItem{

    Review *review = [NSEntityDescription insertNewObjectForEntityForName:@"Review" inManagedObjectContext:managedObjectContext];
    [review setUser:user];
    [review setNewsItem:newsItem];
    [review setReviewDetail:comment];
    NSDate* date = [NSDate date];
    [review setDate:date];
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]){
        //handle error
        NSLog(@"insert error");
        return nil;
    }else{
        return review;
    }

}

-(void)setReviewToUser:(User *)user withReview:(Review *)review
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectedUser = [NSEntityDescription entityForName:@"User" inManagedObjectContext: managedObjectContext];
    [request setEntity:selectedUser];
    
    // request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    //select * from User where email = %@
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", user.email];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *userArray = [managedObjectContext executeFetchRequest:request error:&error];
    if(userArray) {
        User *u = [userArray objectAtIndex:0];
        [u.reviews addObject:review];
        [managedObjectContext save:&error];
        NSLog(@"revew count in user= %lu", [u.reviews count]);
    } else {
        NSLog(@"Error: %@", error);
    }
}

-(void)setReviewToNewsItem:(NewsItem *)newsItem withReview:(Review *)review
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectedItem = [NSEntityDescription entityForName:@"NewsItem" inManagedObjectContext: managedObjectContext];
    [request setEntity:selectedItem];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url = %@", newsItem.url];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *itemArray = [managedObjectContext executeFetchRequest:request error:&error];
    if(itemArray) {
        NewsItem *item = [itemArray objectAtIndex:0];
        [item.reviews addObject:review];
        [managedObjectContext save:&error];
        NSLog(@"review count in new item= %lu", [item.reviews count]);
    } else {
        NSLog(@"Error: %@", error);
    }
}

-(NewsItem *)retriveItems:(NSString *)urlString{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectedItem = [NSEntityDescription entityForName:@"NewsItem" inManagedObjectContext: managedObjectContext];
    [request setEntity:selectedItem];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url = %@", urlString];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *itemArray = [managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"itemarray=%lu",[itemArray count]);
    if ([itemArray count] != 0) {
        NewsItem *newsItem = [itemArray objectAtIndex:0];
        return newsItem;
    }else{
        return nil;
    }
}



@end
