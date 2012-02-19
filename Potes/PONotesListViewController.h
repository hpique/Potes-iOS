//
//  PONotesListViewController.h
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PONoteDetailViewController;

@interface PONotesListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* notes;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (strong, nonatomic) PONoteDetailViewController* detailViewController;

@property (readonly) SEL sortSelector;

- (IBAction) reloadData;
- (IBAction) sortSegmentedControlValueChanged;

@end
