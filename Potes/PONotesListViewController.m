//
//  PONotesListViewController.m
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import "PONotesListViewController.h"
#import "PONotesManager.h"
#import "PONoteDetailViewController.h"

@interface PONotesListViewController (Private)

- (void) prepareForAddNoteSegue:(UIStoryboardSegue*)segue;

@end

@implementation PONotesListViewController

@synthesize notes;
@synthesize tableView;
@synthesize emptyLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setEmptyLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"addNote" isEqualToString:segue.identifier]) {
        [self prepareForAddNoteSegue:segue];
    }
}

# pragma mark - Table View 

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Note"];
    PONote* note = [self.notes objectAtIndex:indexPath.row];
    cell.textLabel.text = note.body;
    return cell;
}

#pragma mark - Private

- (void) prepareForAddNoteSegue:(UIStoryboardSegue*)segue {
    PONoteDetailViewController* vc = segue.destinationViewController;
    vc.title = NSLocalizedString(@"New Note", @"");
    vc.allNotes = self.notes;
}

#pragma mark - Public

- (void) reloadData {
    self.notes = [PONotesManager notes];
    BOOL empty = self.notes.count == 0;
    self.tableView.hidden = empty;
    self.emptyLabel.hidden = !empty;
    [self.tableView reloadData];
}

@end
