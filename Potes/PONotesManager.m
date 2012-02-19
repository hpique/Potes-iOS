//
//  PONotesManager.m
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import "PONotesManager.h"

#define PONotesManagerUserDefaultsKeyNotes @"notes"

@implementation PONotesManager

static NSMutableDictionary* notes_;

+ (NSArray*) notes {
    if (!notes_) {
        NSDictionary* notes = [[NSUserDefaults standardUserDefaults] dictionaryForKey:PONotesManagerUserDefaultsKeyNotes];
        notes_ = [NSMutableDictionary dictionaryWithDictionary:notes];
    }
    return [notes_ allValues];
}

+ (void) addNote:(PONote*)note {
    [notes_ setObject:note forKey:note.noteId];
    [PONotesManager update];
}

+ (void) deleteNote:(PONote*)note {
    [notes_ removeObjectForKey:note.noteId];
    [PONotesManager update];
}

+ (void) update {
    [[NSUserDefaults standardUserDefaults] setObject:notes_ forKey:PONotesManagerUserDefaultsKeyNotes];
}

@end
