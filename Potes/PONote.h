//
//  PONote.h
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PONote : NSObject<NSCoding, NSCopying>

@property (strong, nonatomic) NSString* body;
@property (strong, nonatomic) NSDate* creationDate;
@property (readonly) NSString* freshnessDescription;
@property (strong, nonatomic) NSDate* modificationDate;
@property (strong, nonatomic) NSString* noteId;
@property (readonly) NSString* title;
@property (nonatomic) NSInteger views;
@property (readonly) NSString* viewsDescription;

+ (PONote*) note;

- (NSComparisonResult)compareByTitle:(PONote*)note;
- (NSComparisonResult)compareByModificationDateDescending:(PONote*)note;
- (NSComparisonResult)compareByViewsDescending:(PONote*)note;

- (NSString*) stringFromModificationDate;


@end
