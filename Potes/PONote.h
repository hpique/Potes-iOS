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
@property (strong, nonatomic) NSDate* modificationDate;
@property (readonly) NSString* modificationDateDescription;
@property (strong, nonatomic) NSString* noteId;
@property (readonly) NSString* title;

+ (PONote*) note;

- (NSComparisonResult)compareBody:(PONote*)note;
- (NSComparisonResult)compareModificationDate:(PONote*)note;


@end
