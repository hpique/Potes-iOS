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
@synthesize doneBarButtonItem;
@synthesize addBarButtonItem;

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

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.note) {
        self.title = self.note.title;
        self.textView.text = self.note.body;
        self.note.views++;
        self.navigationItem.rightBarButtonItem = self.addBarButtonItem;
    } else {
        self.title = NSLocalizedString(@"New Note", @"");
        [self.textView becomeFirstResponder];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    if (self.note && self.note.title.length == 0) {
        [PONotesManager deleteNote:self.note];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setDoneBarButtonItem:nil];
    [self setAddBarButtonItem:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction) doneButtonPressed {
    [self.view endEditing:YES];
}

- (IBAction) swipeLeft {
    
}

- (IBAction) swipeRight {
    
}

- (void) keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y,
                                       self.textView.frame.size.width, self.textView.frame.size.height - keyboardFrame.size.height + 5.0)];
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y,
                                       self.textView.frame.size.width, self.textView.frame.size.height + keyboardFrame.size.height - 5.0)];
    [UIView commitAnimations];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)aTextView {
	self.navigationItem.rightBarButtonItem = self.doneBarButtonItem;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!self.note) {
        self.note = [PONote note];
        self.note.views++;
        [PONotesManager addNote:self.note];
    } else {
        self.note.modificationDate = [NSDate date];
    }
    self.note.body = self.textView.text;
    self.title = self.note.title;
}

- (void)textViewDidEndEditing:(UITextView *)aTextView {
    [PONotesManager update];
    self.navigationItem.rightBarButtonItem = self.addBarButtonItem;
}

@end
