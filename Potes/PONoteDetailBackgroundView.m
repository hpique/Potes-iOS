//
//  PONoteDetailBackgroundView.m
//  Potes
//
//  Created by Hermes Pique on 2/19/12.
//  Copyright (c) 2012 Robot Media SL. All rights reserved.
//

#import "PONoteDetailBackgroundView.h"

NSInteger const kPONoteDetailBackgroundViewMarginTop = 42;

#define PONoteDetailBackgroundViewLineHeight 23

@implementation PONoteDetailBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, 0);
	
	CGContextSetLineWidth(context, 1.0);
	CGContextSetRGBStrokeColor(context, 250.0/255.0, 201.0/255.0, 220.0/255.0, 1.0);
	
	int lines = 1 + self.frame.size.height / PONoteDetailBackgroundViewLineHeight;
	for (int i = 0; i < lines;  ++i) {
		CGContextMoveToPoint(context, 0.0, PONoteDetailBackgroundViewLineHeight * i + kPONoteDetailBackgroundViewMarginTop);
		CGContextAddLineToPoint(context, 320.0, PONoteDetailBackgroundViewLineHeight * i + kPONoteDetailBackgroundViewMarginTop);
		CGContextStrokePath(context);
	}
    
    CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 245.0/255.0, 170.0/255.0, 200.0/255.0, 1.0);
	CGContextMoveToPoint(context, 16.0, 0);
	CGContextAddLineToPoint(context, 16.0, self.frame.size.height);
	CGContextStrokePath(context);
}

@end
