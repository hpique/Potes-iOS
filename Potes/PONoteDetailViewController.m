//
//  PONoteDetailViewController.m
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import "PONoteDetailViewController.h"
#import "PONotesManager.h"
#import "PONoteDetailBackgroundView.h"
#import <QuartzCore/QuartzCore.h>

@interface PONoteDetailViewController (Private)

- (void) changeNoteWithTransition:(UIViewAnimationTransition)transition;

@end

@implementation PONoteDetailViewController

@synthesize allNotes;
@synthesize note;
@synthesize noteIndex;
@synthesize textView;
@synthesize doneBarButtonItem;
@synthesize addBarButtonItem;
@synthesize backgroundView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundView.layer.shadowOpacity = 0.1;
    self.backgroundView.layer.shadowRadius = 2;

    if (!self.note) {
        [self.textView becomeFirstResponder];
    }
    
    [self reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    if (self.note && self.note.title.length == 0) {
        [PONotesManager deleteNote:self.note];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTextView:nil];
    [self setDoneBarButtonItem:nil];
    [self setAddBarButtonItem:nil];
    [self setBackgroundView:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

#pragma mark - Actions

- (IBAction) addButtonPressed {
    self.note = nil;
    [self changeNoteWithTransition:UIViewAnimationTransitionCurlUp];
}

- (void) changeNoteAnimationDidStop {
    if (!self.note) {
        [self.textView becomeFirstResponder];
    }
}

- (IBAction) doneButtonPressed {
    [self.view endEditing:YES];
}

- (IBAction) swipeLeft {
    int nextIndex = self.noteIndex + 1;
    if (nextIndex < self.allNotes.count) {
        self.note = [self.allNotes objectAtIndex:nextIndex];
        self.noteIndex = nextIndex;
        [self changeNoteWithTransition:UIViewAnimationTransitionCurlUp];
    }
}

- (IBAction) swipeRight {
    int nextIndex = self.noteIndex - 1;
    if (nextIndex >= 0) {
        self.note = [self.allNotes objectAtIndex:nextIndex];
        self.noteIndex = nextIndex;
        [self changeNoteWithTransition:UIViewAnimationTransitionCurlDown];
    }
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	float yOffset = scrollView.contentOffset.y;
	self.backgroundView.transform = CGAffineTransformMakeTranslation(0, -yOffset - self.textView.contentInset.top);
}

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

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	CGSize newSize = [[change objectForKey:@"new"] CGSizeValue];
	self.backgroundView.frame = CGRectMake(self.backgroundView.frame.origin.x, 
                                           self.backgroundView.frame.origin.y, 
                                           newSize.width + 124.0, 
                                           newSize.height + 480.0);
    [self.backgroundView setNeedsDisplay];
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Notes", @"");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark - Private

- (void) changeNoteWithTransition:(UIViewAnimationTransition)transition {
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(changeNoteAnimationDidStop)];
    [self reloadData];
    [UIView commitAnimations];
}

#pragma mark - Public 

- (void) reloadData {
    if (self.note) {
        self.title = self.note.title;
        self.textView.text = self.note.body;
        self.note.views++;
    } else {
        self.title = NSLocalizedString(@"New Note", @"");
        self.textView.text = nil;
        self.noteIndex = -1;
    } 
}

@end
