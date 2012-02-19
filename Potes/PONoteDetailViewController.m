//
//  PONoteDetailViewController.m
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import "PONoteDetailViewController.h"
#import "PONotesManager.h"

@implementation PONoteDetailViewController

@synthesize allNotes;
@synthesize note;
@synthesize noteIndex;
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewWillDisappear:(BOOL)animated {
    self.note = [PONote note];
    self.note.body = self.textView.text;
    [PONotesManager addNote:self.note];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction) addButtonPressed {
    
}

- (IBAction) swipeLeft {
    
}

- (IBAction) swipeRight {
    
}


@end
