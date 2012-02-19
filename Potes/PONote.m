//
//  PONote.m
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import "PONote.h"

#define PONoteCodeKeyBody @"body"
#define PONoteCodeKeyCreationDate @"creationDate"
#define PONoteCodeKeyModificationDate @"modificationDate"
#define PONoteCodeKeyNoteId @"noteId"

@implementation PONote

@synthesize body;
@synthesize creationDate;
@synthesize modificationDate;
@synthesize noteId;

- (id) init {
    self = [super init];
    if (self) {
        self.noteId = [[NSProcessInfo processInfo] globallyUniqueString];
        self.creationDate = [NSDate date];
        self.modificationDate = self.creationDate;
    }
    return self;
}

+ (PONote*) note {
    return [[PONote alloc] init];
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {    
    [aCoder encodeObject:self.body forKey:PONoteCodeKeyBody];
    [aCoder encodeObject:self.creationDate forKey:PONoteCodeKeyCreationDate];
    [aCoder encodeObject:self.modificationDate forKey:PONoteCodeKeyModificationDate];
    [aCoder encodeObject:self.noteId forKey:PONoteCodeKeyNoteId];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init]))
    {
        self.body = [aDecoder decodeObjectForKey:PONoteCodeKeyBody];
        self.creationDate = [aDecoder decodeObjectForKey:PONoteCodeKeyCreationDate];
        self.modificationDate = [aDecoder decodeObjectForKey:PONoteCodeKeyModificationDate];
        self.noteId = [aDecoder decodeObjectForKey:PONoteCodeKeyNoteId];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    PONote *note = [[PONote allocWithZone:zone] init];
    note.body = [self.body copy];
    note.creationDate = [self.creationDate copy];
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

#pragma mark - Properties

- (NSString*) modificationDateDescription {
    NSTimeInterval interval = -[self.modificationDate timeIntervalSinceNow];
    if (interval < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"%.0lfs ago", @""), interval];
    } else if (interval < 3600) {
        return [NSString stringWithFormat:NSLocalizedString(@"%.0lfm ago", @""), interval / 60];
    } else if (interval < 86400) {
        return [NSString stringWithFormat:NSLocalizedString(@"%.0lfh ago", @""), interval / 3600];
    } else if (interval < 31556926) {
        return [NSString stringWithFormat:NSLocalizedString(@"%.0lfd ago", @""), interval / 86400];
    } else {
        return NSLocalizedString(@"a while ago", @"");
    }
}
- (NSString*) title {
    return [self.body stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
