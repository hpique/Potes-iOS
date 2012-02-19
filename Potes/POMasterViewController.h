//
//  POMasterViewController.h
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PODetailViewController;

@interface POMasterViewController : UITableViewController

@property (strong, nonatomic) PODetailViewController *detailViewController;

@end
