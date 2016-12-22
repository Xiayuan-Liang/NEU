//
//  MainViewController.h
//  iNews
//
//  Created by 梁夏源 on 4/4/16.
//  Copyright © 2016 Xiayuan Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "KASlideShow.h"
@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
//<KASlideShowDelegate, UITableViewDelegate, UITableViewDataSource>

//@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UITableView *NewsTable;
//@property (strong,nonatomic) IBOutlet KASlideShow * slideshow;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property NSMutableArray *newsItemArray;
- (IBAction)go:(id)sender;

@end
