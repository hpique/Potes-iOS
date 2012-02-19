//
//  PONotesListViewControlleriPad.m
//  Potes
//
//  Created by Hermes Pique on 2/20/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import "PONotesListViewControlleriPad.h"
#import "PONoteDetailViewController.h"

@implementation PONotesListViewControlleriPad

@synthesize detailViewController;

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (PONoteDetailViewController*)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewDidUnload
{
    [self setDetailViewController:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table View

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    int newIndex = indexPath.row;
    int currentIndex = self.detailViewController.noteIndex;
    
    if (newIndex == currentIndex) return; // Do nothing
    
    BOOL forward = currentIndex < newIndex;
    self.detailViewController.note = [self.notes objectAtIndex:newIndex];
    self.detailViewController.noteIndex = newIndex;
    [self.detailViewController changeNoteWithTransition:forward ? UIViewAnimationTransitionCurlUp : UIViewAnimationTransitionCurlDown];
}

#pragma mark - PONotesListViewController

- (void) reloadData {
    [super reloadData];
    self.detailViewController.allNotes = self.notes;
    self.detailViewController.noteIndex = [self.notes indexOfObject:self.detailViewController.note];
}

@end
