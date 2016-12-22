//
//  RegisterViewController.h
//  iNews
//
//  Created by 梁夏源 on 4/19/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UITableViewController 
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPasssword2;

- (IBAction)signUp:(id)sender;
@end
