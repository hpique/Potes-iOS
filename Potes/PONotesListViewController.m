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

#define POUserDefaultKeySortSelectedIndex @"SortSelectedIndex"

@interface PONotesListViewController (Private)

- (NSString*) detailTextForNote:(PONote*)note;
- (void) prepareForAddNoteSegue:(UIStoryboardSegue*)segue;
- (void) prepareForSelectNoteSegue:(UIStoryboardSegue*)segue;
- (void) setNavigationTitle;

@end

@implementation PONotesListViewController

@synthesize notes;
@synthesize tableView;
@synthesize sortSegmentedControl;
@synthesize emptyLabel;
@synthesize detailViewController;

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
    
    self.sortSegmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:POUserDefaultKeySortSelectedIndex];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.detailViewController = (PONoteDetailViewController*)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
    [self reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidUnload
{
    [self setDetailViewController:nil];
    [self setTableView:nil];
    [self setEmptyLabel:nil];
    [self setSortSegmentedControl:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        PONote* note = [self.notes objectAtIndex:indexPath.row];
        [PONotesManager deleteNote:note];
		[self.notes removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self setNavigationTitle];
	}   
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) return; // iPhone uses segue

    int newIndex = indexPath.row;
    int currentIndex = self.detailViewController.noteIndex;
    
    if (newIndex == currentIndex) return; // Do nothing
    
    BOOL forward = currentIndex < newIndex;
    self.detailViewController.note = [self.notes objectAtIndex:newIndex];
    self.detailViewController.noteIndex = newIndex;
    [self.detailViewController changeNoteWithTransition:forward ? UIViewAnimationTransitionCurlUp : UIViewAnimationTransitionCurlDown];
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

- (void) setNavigationTitle {
    if (self.notes.count == 0) {
        self.title = NSLocalizedString(@"Potes", @"%d");  
    } else {
        self.title = [NSString stringWithFormat:NSLocalizedString(@"Potes (%d)", @"%d"), self.notes.count];
    }  
}

#pragma mark - Actions

- (IBAction) reloadData {
    NSArray* unmutableNotes = [[PONotesManager notes] sortedArrayUsingSelector:self.sortSelector];
    self.notes = [NSMutableArray arrayWithArray:unmutableNotes];
    
    BOOL empty = self.notes.count == 0;
    self.tableView.hidden = empty;
    self.emptyLabel.hidden = !empty;

    [self setNavigationTitle];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.detailViewController.allNotes = self.notes;
        self.detailViewController.noteIndex = [self.notes indexOfObject:self.detailViewController.note];
    }
    
    [self.tableView reloadData];
}

- (IBAction) sortSegmentedControlValueChanged {
    [[NSUserDefaults standardUserDefaults] setInteger:self.sortSegmentedControl.selectedSegmentIndex forKey:POUserDefaultKeySortSelectedIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self reloadData];
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
