//
//  LoginViewController.h
//  iNews
//
//  Created by 梁夏源 on 4/10/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController 
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)submit:(id)sender;

//- (IBAction)cancel:(id)sender;

@end
