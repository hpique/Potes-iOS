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

- (NSString*) detailTextForNote:(PONote*)note;
- (void) prepareForAddNoteSegue:(UIStoryboardSegue*)segue;
- (void) prepareForSelectNoteSegue:(UIStoryboardSegue*)segue;

@end

@implementation PONotesListViewController

@synthesize notes;
@synthesize tableView;
@synthesize sortSegmentedControl;
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
    [self setSortSegmentedControl:nil];
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
    } else if ([@"selectNote" isEqualToString:segue.identifier]) {
        [self prepareForSelectNoteSegue:segue];
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
    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = [self detailTextForNote:note];
    return cell;
}

#pragma mark - Private

- (NSString*) detailTextForNote:(PONote*)note {
    int sortIndex = self.sortSegmentedControl.selectedSegmentIndex;
    switch (sortIndex) {
        case 0:
            return [note stringFromModificationDate];
        case 1:
            return note.freshnessDescription;
        default:
            return note.viewsDescription;
    }
}

- (void) prepareForAddNoteSegue:(UIStoryboardSegue*)segue {
    PONoteDetailViewController* vc = segue.destinationViewController;
    vc.allNotes = self.notes;
}

- (void) prepareForSelectNoteSegue:(UIStoryboardSegue*)segue {
    PONoteDetailViewController* vc = segue.destinationViewController;
    int index = self.tableView.indexPathForSelectedRow.row;
    vc.note = [self.notes objectAtIndex:index];
    vc.noteIndex = index;
    vc.allNotes = self.notes;
}

#pragma mark - Actions

- (IBAction) reloadData {
    self.notes = [[PONotesManager notes] sortedArrayUsingSelector:self.sortSelector];
    
    BOOL empty = self.notes.count == 0;
    self.tableView.hidden = empty;
    self.emptyLabel.hidden = !empty;

    if (empty) {
        self.title = NSLocalizedString(@"Potes", @"%d");  
    } else {
        self.title = [NSString stringWithFormat:NSLocalizedString(@"Potes (%d)", @"%d"), self.notes.count];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Properties

- (SEL) sortSelector {
    int sortIndex = self.sortSegmentedControl.selectedSegmentIndex;
    switch (sortIndex) {
        case 0:
            return @selector(compareByTitle:);
        case 1:
            return @selector(compareByModificationDateDescending:);
        default:
            return @selector(compareByViewsDescending:);
    }
}

@end
