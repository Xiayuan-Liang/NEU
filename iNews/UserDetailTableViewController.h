//
//  UserDetailTableViewController.h
//  iNews
//
//  Created by 梁夏源 on 4/21/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableViewController : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *imgButton;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) UIImage *userImage;

- (IBAction)signout:(id)sender;
- (IBAction)selectImage:(id)sender;
- (void)save;

@end
