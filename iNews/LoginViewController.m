//
//  LoginViewController.m
//  iNews
//
//  Created by 梁夏源 on 4/10/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import "LoginViewController.h"
#import "CSNotificationView.h"
#import "Dao.h"
#import "User.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    Dao *dao;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //click outside the textfield dissmiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)submit:(id)sender {
    if([_txtEmail.text isEqualToString:@""] ||
       [_txtPassword.text isEqualToString:@""]){
        [CSNotificationView showInViewController:self.navigationController
                                           style:CSNotificationViewStyleError
                                         message:@"Please enter information."];
    }else{
       dao = [[Dao alloc] initWithDelegate];
       User *user = [dao authenticateUser:_txtEmail.text withPassword:_txtPassword.text];
        if (user != nil) {
    
            //to remember the login status and user info.
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:user.username forKey:@"username"];
            [defaults setObject:user.password forKey:@"password"];
            [defaults setObject:user.icon forKey:@"icon"];
            [defaults setObject:user.email forKey:@"email"];
            [defaults setBool:YES forKey:@"loggedIn"];
            
            [defaults synchronize];
            
            //jump to main page
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainViewController *mainVC =
                [storyboard instantiateViewControllerWithIdentifier:@"revealVC"];
            
                [self presentViewController:mainVC
                                   animated:YES
                                 completion:nil];
        }
        else{
            [CSNotificationView showInViewController:self.navigationController
                                               style:CSNotificationViewStyleError
                                             message:@"Wrong Email or Password."];
        }
    }
//    NSString *strURL = [NSString stringWithFormat:@"http://localhost/login.php?un=%@&pw=%@", _txtEmail, _txtPassword.text];
//    //to exectue php code
//    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
//    //to receive the returned value
//    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
}

#pragma mark - Don't implement any of the methods below when you use the static table view:
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

//- (IBAction)cancel:(id)sender {
    //when do not have nav controller
   // [self dismissViewControllerAnimated:YES completion:nil];
    //when use nav controller
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
  //  [self.revealViewController.navigationController popViewControllerAnimated:YES];
  //  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MainViewController *add =
//    [storyboard instantiateViewControllerWithIdentifier:@"revealVC"];
//    
//    [self presentViewController:add
//                       animated:YES
//                     completion:nil];

//}



@end
