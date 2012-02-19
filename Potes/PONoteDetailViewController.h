//
//  PONoteDetailViewController.h
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PONote;

@interface PONoteDetailViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) NSArray* allNotes;
@property (strong, nonatomic) PONote* note;
@property (nonatomic) int noteIndex;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;

- (IBAction) addButtonPressed;
- (IBAction) doneButtonPressed;
- (IBAction) swipeLeft;
- (IBAction) swipeRight;

- (void) reloadData;

@end
