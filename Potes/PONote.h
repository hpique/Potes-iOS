//
//  PONote.h
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PONote : NSObject<NSCoding, NSCopying> {
    NSString* noteId;
    NSString* body;
    NSDate* modificationDate;
}

@property (strong, nonatomic) NSString* body;
@property (strong, nonatomic) NSDate* modificationDate;
@property (strong, nonatomic) NSString* noteId;

+ (PONote*) note;

- (NSComparisonResult)compareBody:(PONote*)note;
- (NSComparisonResult)compareModificationDate:(PONote*)note;


@end
