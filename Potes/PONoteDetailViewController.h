//
//  PONoteDetailViewController.h
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PONote;
@class PONoteDetailBackgroundView;

@interface PONoteDetailViewController : UIViewController<UITextViewDelegate, UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) NSArray* allNotes;
@property (strong, nonatomic) PONote* note;
@property (nonatomic) int noteIndex;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
@property (weak, nonatomic) IBOutlet PONoteDetailBackgroundView *backgroundView;

- (IBAction) addButtonPressed;
- (IBAction) doneButtonPressed;
- (IBAction) swipeLeft;
- (IBAction) swipeRight;

- (void) changeNoteWithTransition:(UIViewAnimationTransition)transition;
- (void) reloadData;

@end
