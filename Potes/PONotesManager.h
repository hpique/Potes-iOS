//
//  PONotesManager.h
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PONote.h"

@interface PONotesManager : NSObject

+ (NSArray*) notes;

+ (void) addNote:(PONote*)note;

+ (void) deleteNote:(PONote*)note;

+ (void) update;

@end
