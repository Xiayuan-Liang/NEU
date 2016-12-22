//
//  MenuViewController.m
//  iNews
//
//  Created by 梁夏源 on 4/5/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "UserDetailTableViewController.h"
#import "User.h"

//@implementation SWUITableViewCell
//@end

@interface MenuViewController ()

@end

@implementation MenuViewController
{
    NSArray *menuItems;
    UILabel *usernameLabel;
    UIImageView *userImageView;
    BOOL loggedIn;
    NSInteger rowSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    menuItems =@[@"account", @"home", @"world", @"travel", @"health"]; //same as cell identifier
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        userImageView = (UIImageView *)[cell.contentView viewWithTag:100];
        usernameLabel = (UILabel *)[cell.contentView viewWithTag:200];
        
        //Get the stored user info before the view loads
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *username = [defaults objectForKey:@"username"];
        NSData *imageData = [defaults dataForKey:@"icon"];
        UIImage *userImage = [UIImage imageWithData:imageData];
        loggedIn = [defaults objectForKey:@"loggedIn"];
//        
        //Update the UI elements with saved data
        NSLog(@"in cellForRow, loggedin= %d",loggedIn);
        if (!loggedIn) {
              usernameLabel.text = @"Click to Sign In";
        }else{
            usernameLabel.text = username;
            if (userImage != nil) {
                userImageView.image = userImage;
            }
        }
      
        
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    else {
        return 56;
    }
}

#pragma mark - TableView delegate, is used when a tableview connect many segues
//invoke this first, then invoke prepareForSegue:
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
 (NSIndexPath *)indexPath{
     rowSelected = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!rowSelected == 0){
          [self performSegueWithIdentifier:@"mainDelegate" sender:tableView];

    }else{
        if (loggedIn) {
          [self performSegueWithIdentifier:@"userDetailDelegate" sender:tableView];
        }else{
          [self performSegueWithIdentifier:@"loginDelegate" sender:tableView];
        }
    }
 }

#pragma mark - is used when one cell connect a segue
//After performSegueWithIdentifier:sender: your view controler will call
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
  //  NSIndexPath *indexPath = [self.tableView  indexPathForSelectedRow];
    UINavigationController *navViewController = (UINavigationController*)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"mainDelegate"]) {
        MainViewController *mainVC = (MainViewController*)[navViewController topViewController];
        mainVC.title = [[menuItems objectAtIndex:rowSelected] capitalizedString];
    }
    else if ([segue.identifier isEqualToString:@"loginDelegate"]) {
        LoginViewController *loginVC = (LoginViewController*)[navViewController topViewController];
        loginVC.title = [[menuItems objectAtIndex:rowSelected] capitalizedString];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)completeSave:(UIStoryboardSegue *)segue{
    UserDetailTableViewController *detailVC = segue.sourceViewController;
    usernameLabel.text = detailVC.username;
    if (detailVC.userImage != nil) {
         userImageView.image = detailVC.userImage;
    }
}

@end
