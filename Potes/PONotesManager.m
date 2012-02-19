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
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:PONotesManagerUserDefaultsKeyNotes];
        if (data) {
            NSDictionary* notes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            notes_ = [NSMutableDictionary dictionaryWithDictionary:notes];
        } else {
            notes_ = [NSMutableDictionary dictionary];
        }
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
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:notes_];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:PONotesManagerUserDefaultsKeyNotes];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
