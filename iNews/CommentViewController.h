//
//  CommentViewController.h
//  iNews
//
//  Created by 梁夏源 on 4/29/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property(retain) NSDictionary *item;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtComment;
@property (weak, nonatomic) IBOutlet UITableView *reviewTable;


- (IBAction)sendComment:(id)sender;

@end
