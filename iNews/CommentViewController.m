//
//  CommentViewController.m
//  iNews
//
//  Created by 梁夏源 on 4/29/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import "CommentViewController.h"
#import "Dao.h"
#import "CSNotificationView.h"
#import "NewsItem.h"
@interface CommentViewController ()

@end

@implementation CommentViewController
{
    Dao *dao;
    NSMutableArray *reviewArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      dao = [[Dao alloc] initWithDelegate];
    reviewArray = [[NSMutableArray alloc] init];
    
    //click outside the textfield dissmiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    _titleLabel.text = [self.item objectForKey:@"title"];
    
    NSArray *multimedia = [self.item objectForKey:@"multimedia"];
    if ([multimedia isKindOfClass:[NSArray class]]) {  //CHECK is important!
        NSDictionary *mediumThreeByTwo210 = multimedia[3];
        NSString *imageUrl = [mediumThreeByTwo210 objectForKey:@"url"];
        UIImage *newsImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        _imageLabel.image = newsImage;
        
        _captionLabel.text = [mediumThreeByTwo210 objectForKey:@"caption"];
    }
    else {
        //  NSLog(@"multimedia is a string");
        _imageLabel.image = nil;
        _captionLabel.text = nil;
    }
    
    //Get the seleted item reviews  
    NewsItem *it = [dao retriveItems:[self.item objectForKey:@"url"]];
    if (it) {
        for(Review *r in it.reviews){
            NSLog(@"%@", r.user.email);
            [reviewArray addObject:r];
        }
    }else{
        NSLog(@"no item yet");
    }

}

//click outside the textfield dissmiss the keyboard
-(void)dismissKeyboard {
    //    [_txtEmail resignFirstResponder];
    //    [_txtPassword resignFirstResponder];
    [self.view endEditing:YES];
}

//overriden method: click 'return' dismiss the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [reviewArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //init cell object
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (reviewArray) {
        Review *review = [reviewArray objectAtIndex:indexPath.row ];
        
        UIImageView *imageView= (UIImageView *)[cell.contentView viewWithTag:100];
        NSData *imageData = review.user.icon;
        
        if (imageData != nil) {
            UIImage *icon = [UIImage imageWithData:imageData];
            imageView.image = icon;
        }
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:200];
        nameLabel.text = review.user.username;
        
        UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:300];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateLabel.text = [dateFormatter stringFromDate:review.date];
        
        UILabel *commentLabel = (UILabel *)[cell.contentView viewWithTag:400];
        commentLabel.text = review.reviewDetail;
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendComment:(id)sender {
    //if user not loggin yet, to login page
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool loggedIn = [defaults objectForKey:@"loggedIn"];
    if (!loggedIn) {
        [self performSegueWithIdentifier:@"CommentToLogin" sender:self.reviewTable];
    }else{
    //Get the logined user information
    NSString *email = [defaults objectForKey:@"email"];
    NSString *password = [defaults objectForKey:@"password"];

    User *user = [dao authenticateUser:email withPassword:password];
    Review *review;
    
    //retrive News item OR create one
    NSString *itemUrl = [_item objectForKey:@"url"]; //acts as item id
    NewsItem *existItem = [dao retriveItems:itemUrl];
    
    if (existItem) {  //the item has record, modify it
       review = [dao createReview:_txtComment.text inUser:user andNewsItem:existItem ];
       [dao setReviewToUser:user withReview:review];
        [dao setReviewToNewsItem:existItem withReview:review];
    }
    else{ //no record, create a new item
        NewsItem *newsItem = [dao createNewsItem:itemUrl];
        review = [dao createReview:_txtComment.text inUser:user andNewsItem:newsItem];
        [dao setReviewToUser:user withReview:review];
        [dao setReviewToNewsItem:newsItem withReview:review];
    }
        [_txtComment setText:@""];
        [CSNotificationView showInViewController:self.navigationController
                                               style:CSNotificationViewStyleSuccess
                                             message:@"Send Succeed!"];

        [self.reviewTable reloadData];
    }
}
@end
