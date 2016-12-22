//
//  RegisterViewController.m
//  iNews
//
//  Created by 梁夏源 on 4/19/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import "RegisterViewController.h"
#import "CSNotificationView.h"
#import "Dao.h"
#import "User.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    Dao *dao;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    dao = [[Dao alloc] initWithDelegate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
#pragma mark - Don't implement any of the methods below when you use the static table view:
/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
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

- (IBAction)signUp:(id)sender {

    BOOL email_hasText = [_txtEmail hasText];
    BOOL pw_hasText = [_txtPassword hasText];
    BOOL pw2_hasText = [_txtPasssword2 hasText];
    
    //1.validate if the textfields are empty
    if (email_hasText && pw_hasText && pw2_hasText) {
        //2.validate email format
        NSInteger email = [self validEmail:[_txtEmail text]];
        if (email) {
            //3.validate if passwords match
            if ([_txtPassword.text isEqualToString:_txtPasssword2.text]) {
                //4.check DB if user is registered
                BOOL isRegistered = [dao retriveUsers: _txtEmail.text];
                if(!isRegistered){
                    //5. create a new user
                    BOOL succeed = [dao createUser:_txtEmail.text withPassword:_txtPassword.text];
                    if (succeed) {
                        [CSNotificationView showInViewController:self.navigationController
                                                           style:CSNotificationViewStyleSuccess
                                                         message:@"Sign Up Succeed!"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [CSNotificationView showInViewController:self.navigationController
                                                           style:CSNotificationViewStyleError
                                                         message:@"System Error."];
                    }
                }
                else{ 
                    [CSNotificationView showInViewController:self.navigationController
                                                               style:CSNotificationViewStyleError
                                                             message:@"Email already exists."];
                            }
            }
            else{
                [CSNotificationView showInViewController:self.navigationController
                                                   style:CSNotificationViewStyleError
                                                 message:@"Password Not Match."];
            }
        }
        else{
            [CSNotificationView showInViewController:self.navigationController
                                               style:CSNotificationViewStyleError
                                             message:@"Incorrect Email Format."];
        }
    }
    else{
        [CSNotificationView showInViewController:self.navigationController
                                           style:CSNotificationViewStyleError
                                         message:@"All Fields Required."];
    }
    
}

- (BOOL)validEmail:(NSString *)input {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:input];
}

//click outside the textfield dissmiss the keyboard
-(void)dismissKeyboard {
   [self.view endEditing:YES];
}

//overriden method: click 'return' dismiss the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
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


@end
