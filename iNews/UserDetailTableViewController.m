//
//  UserDetailTableViewController.m
//  iNews
//
//  Created by 梁夏源 on 4/21/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import "UserDetailTableViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "Dao.h"
#import "CSNotificationView.h"
#import "CommentHistoryViewController.h"

@interface UserDetailTableViewController ()

@end

@implementation UserDetailTableViewController
{
    Dao *dao;
}
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
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //Grab the user data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
    NSString *email = [defaults objectForKey:@"email"];
    NSData *imageData = [defaults dataForKey:@"icon"];
    _username = [defaults objectForKey:@"username"];


    [self.txtEmail setText:email];
    [self.txtEmail setEnabled:NO];
    [self.txtName setText:_username];
    
    if (imageData != nil) {
        _userImage = [UIImage imageWithData:imageData];
        [self.imgButton setImage:_userImage forState:UIControlStateNormal];
    }
        //use default img if user does not set
        //        UIImage *defaultImg = [UIImage imageNamed:@"Gender Neutral User Filled-50.png"];
        //        [self.imgButton setImage:defaultImg forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)signout:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    //jump to main page
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainVC =
    [storyboard instantiateViewControllerWithIdentifier:@"revealVC"];
    
    [self presentViewController:mainVC
                       animated:YES
                     completion:nil];
    
}

- (IBAction)selectImage:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
    {
        
        _userImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        //display the chosen image
        [self.imgButton setImage:_userImage forState:UIControlStateNormal];
    
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)save {
    _username = _txtName.text;
  //  NSData *imageData = UIImageJPEGRepresentation(_userImage, 100);
    NSData *imageData = UIImagePNGRepresentation(_userImage);
    //store user data in NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_username forKey:@"username"];
    [defaults setObject:imageData forKey:@"icon"];
    [defaults synchronize];
    
    //store user data in DB
    dao = [[Dao alloc] initWithDelegate];
    [dao modifiyUser:[defaults objectForKey:@"email"] withName:_username andIcon:imageData];
}


 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"completeSave"]) {
         //do the save method
         [self save];
         [CSNotificationView showInViewController:self.navigationController
                                            style:CSNotificationViewStyleSuccess
                                          message:@"Save Succeed!"];
     }else if ([segue.identifier isEqualToString:@"historySegue"]) {
         CommentHistoryViewController *historylVC = [segue destinationViewController];
     }
 }


/*
#pragma mark - Table view data source
#pragma mark - Don't implement any of the methods below when you use the static table view:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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




@end
