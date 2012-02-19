//
//  PONote.m
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import "PONote.h"

#define PONoteCodeKeyBody @"body"
#define PONoteCodeKeyModificationDate @"modificationDate"
#define PONoteCodeKeyNoteId @"noteId"

@implementation PONote

@synthesize body;
@synthesize modificationDate;
@synthesize noteId;

- (id) init {
    self = [super init];
    if (self) {
        self.noteId = [[NSProcessInfo processInfo] globallyUniqueString];
        self.modificationDate = [NSDate date];
    }
    return self;
}

+ (PONote*) note {
    return [[PONote alloc] init];
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {    
    [aCoder encodeObject:self.body forKey:PONoteCodeKeyBody];
    [aCoder encodeObject:self.modificationDate forKey:PONoteCodeKeyModificationDate];
    [aCoder encodeObject:self.noteId forKey:PONoteCodeKeyNoteId];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init]))
    {
        self.body = [aDecoder decodeObjectForKey:PONoteCodeKeyBody];
        self.modificationDate = [aDecoder decodeObjectForKey:PONoteCodeKeyModificationDate];
        self.noteId = [aDecoder decodeObjectForKey:PONoteCodeKeyNoteId];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    PONote *note = [[PONote allocWithZone:zone] init];
    note.body = [self.body copy];
    note.modificationDate = [self.modificationDate copy];
    note.noteId = [self.noteId copy];
    return note;
}

#pragma mark - Public

- (NSComparisonResult)compareBody:(PONote*)note {
    return [self.body compare:note.body];
}

- (NSComparisonResult)compareModificationDate:(PONote*)note {
    return [self.modificationDate compare:note.modificationDate];
}


@end
