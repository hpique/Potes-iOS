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
#define PONoteCodeKeyViews @"views"

@implementation PONote

@synthesize body;
@synthesize creationDate;
@synthesize modificationDate;
@synthesize noteId;
@synthesize views;

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
    [aCoder encodeInteger:self.views forKey:PONoteCodeKeyViews];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init]))
    {
        self.body = [aDecoder decodeObjectForKey:PONoteCodeKeyBody];
        self.creationDate = [aDecoder decodeObjectForKey:PONoteCodeKeyCreationDate];
        self.modificationDate = [aDecoder decodeObjectForKey:PONoteCodeKeyModificationDate];
        self.noteId = [aDecoder decodeObjectForKey:PONoteCodeKeyNoteId];
        self.views = [aDecoder decodeIntegerForKey:PONoteCodeKeyViews];
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
    note.views = self.views;
    return note;
}

#pragma mark - Public

- (NSComparisonResult)compareByTitle:(PONote*)note {
    NSComparisonResult comparison = [self.title compare:note.title];
    if (comparison == NSOrderedSame) {
        return [self.modificationDate compare:note.modificationDate] * -1;
    }
    return comparison;
}

- (NSComparisonResult)compareByModificationDateDescending:(PONote*)note {
    return [self.modificationDate compare:note.modificationDate] * -1;
}

- (NSComparisonResult)compareByViewsDescending:(PONote*)note {
    if (self.views == note.views) {
        return [self compareByTitle:note];
    } else {
        return self.views > note.views ? -1 : 1;
    }
}

- (NSString*) stringFromModificationDate {
    NSDateComponents *myDate = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.modificationDate];
    NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    BOOL today = myDate.day == todayDate.day && myDate.month == todayDate.month && myDate.year == todayDate.year && myDate.era == todayDate.era;
    
    return [NSDateFormatter localizedStringFromDate:self.modificationDate dateStyle:today ? NSDateFormatterNoStyle : NSDateFormatterShortStyle timeStyle:today ?NSDateFormatterShortStyle : NSDateFormatterNoStyle];
}

#pragma mark - Properties

- (NSString*) freshnessDescription {
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
    return [[[self.body stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@"\n"] objectAtIndex:0];
}

- (NSString*) viewsDescription {
    if (self.views == 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d view", @""), self.views];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"%d views", @""), self.views];
    }
}

@end
