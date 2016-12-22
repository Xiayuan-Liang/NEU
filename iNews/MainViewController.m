//
//  MainViewController.m
//  iNews
//
//  Created by 梁夏源 on 4/4/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "UserDetailTableViewController.h"
#import "AppDelegate.h"
#import "CommentViewController.h"
#import "Dao.h"
@interface MainViewController ()

@end

@implementation MainViewController
{
  NSString *section;
  Dao *dao;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_newsItemArray == nil) {
        _newsItemArray = [[NSMutableArray alloc] init];
    }
    dao = [[Dao alloc] initWithDelegate];
    
    if ( self.title == nil ) {
        self.title = @"Home";
    }
    section = [self.title lowercaseString];

    [self loadDataUsingNSURLConnection];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}

#pragma mark - networking calls
-(void)loadDataUsingNSURLConnection
{
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"http://api.nytimes.com/svc/topstories/v1/%@.json", section]];
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"api-key" value:@"c2ed21d2b20b4e4baee2fe0b3c56e897"];
   // NSURLQueryItem *count = [NSURLQueryItem queryItemWithName:@"count" value:@"10"];
   // components.queryItems = @[ search, count ];
     components.queryItems = @[ apiKey];
    NSURL *url = components.URL;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data.length > 0 && connectionError == nil){
           [self processResponseUsingData:data];
        }
    }];
}

-(void)processResponseUsingData:(NSData *)data
{
    NSError *parseJsonError = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseJsonError];
    if (!parseJsonError) {
        _newsItemArray = [jsonDict objectForKey:@"results"];
        
       dispatch_async(dispatch_get_main_queue(), ^{
          [self.NewsTable reloadData];
        });
    }
}

//-(void)loadAPIData{
//    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //get data succeed
//        if (data.length > 0 && error == nil)
//        {
//            
//            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
//                                                                     options:0
//                                                                       error:NULL];
//            _newsItems = [response objectForKey:@"results"];
//            NSLog(@"newitems = %lu", _newsItems.count);
//            if (_newsItems.count > 0) {
//                [self.NewsTable reloadData];
//           }
//        }
//    }]resume];
//
//}

#pragma mark - Load API data
//-(void)viewDidAppear:(BOOL)animated{
//   NSLog(@"did appear");
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    NSLog(@"will appear");
//    [self loadAPIData];
//}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:(BOOL)animated];    // Call the super class implementation.
//    // Usually calling super class implementation is done before self class implementation, but it's up to your application.
//    [_slideshow stop];
//}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count= %lu",[_newsItemArray count]);
    return [_newsItemArray count];
}

//“cellForRowAtIndexPath:” is called every time when a table row is displayed
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"newsItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //init cell object
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *item = [_newsItemArray objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:100];
    titleLabel.text = [item objectForKey:@"title"];
   
    UILabel *abstractLabel = (UILabel *)[cell.contentView viewWithTag:200];
     abstractLabel.text = [item objectForKey:@"abstract"];
    
    UIImageView *newsImage= (UIImageView *)[cell.contentView viewWithTag:300];
    NSArray *multimedia = [item objectForKey:@"multimedia"];
                if ([multimedia isKindOfClass:[NSArray class]]) {  //CHECK is important!
                    NSDictionary *thumbMedia = multimedia[0];
                    NSString *imageUrl = [thumbMedia objectForKey:@"url"];
                    UIImage *thumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
                      newsImage.image = thumb;
                }
                else {
                  //  NSLog(@"multimedia is a string");
                    newsImage.image = nil;
                }
    
    //get review amout of item
//    NSString *itemUrl = [item objectForKey:@"url"];
//    NewsItem *itemObj = [dao retriveItems:itemUrl];
//    NSUInteger reviewCount = [itemObj.reviews count];
//    UILabel *countLabel = (UILabel *)[cell.contentView viewWithTag:500];
//    countLabel.text = [NSMutableString stringWithFormat:@"%tu %@", reviewCount, @"comments"];
    
//    UIButton *commentBtn = (UIButton *)[cell.contentView viewWithTag:400];
//    commentBtn.tag = indexPath.row;
//    NSLog(@"row=%lu",indexPath.row);
//    NSLog(@"tag=%lu",commentBtn.tag);
    return cell;
}

#pragma mark - KASlideShow delegate
/*
- (void)kaSlideShowWillShowNext:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowWillShowNext, index : %@",@(slideShow.currentIndex));
}

- (void)kaSlideShowWillShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowWillShowPrevious, index : %@",@(slideShow.currentIndex));
}

- (void) kaSlideShowDidShowNext:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowDidNext, index : %@",@(slideShow.currentIndex));
}

-(void)kaSlideShowDidShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowDidPrevious, index : %@",@(slideShow.currentIndex));
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    NSDictionary *item = [_newsItemArray objectAtIndex:indexPath.row];
    NSString *urlString = [item objectForKey:@"url"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString: urlString]];

}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.NewsTable indexPathForCell:clickedCell];
    
    if ([segue.identifier isEqualToString:@"commentSegue"]) {
        //get selected information
         NSDictionary *item = [_newsItemArray objectAtIndex:clickedButtonPath.row];
        CommentViewController *commentVC = [segue destinationViewController];
        commentVC.item = item; //pass selected patient to detailVC
    }
}


- (IBAction)cancelSignIn:(UIStoryboardSegue *)segue{
    
}


@end
