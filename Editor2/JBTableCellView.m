//
//  JBTableCellView.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-15.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBTableCellView.h"

@implementation JBTableCellView
@synthesize titleTextLabel = _titleTextLabel;
@synthesize dateTextLabel = _dateTextLabel;
@synthesize summaryTextLabel = _summaryTextLabel;


- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
	[super setBackgroundStyle:backgroundStyle];
	
	if (NSBackgroundStyleDark == backgroundStyle) {
		for (NSTextField *text in [self subviews]) {
			if (![text isKindOfClass:[NSTextField class]]) continue;
			
			
			[text setTextColor:[NSColor whiteColor]];
		}
	} else if (NSBackgroundStyleLight == backgroundStyle) {
		// set them back to normal
		[_titleTextLabel setTextColor:[NSColor colorWithCalibratedWhite:0.000 alpha:1.000]];
		[_dateTextLabel setTextColor:[NSColor colorWithCalibratedRed:0.092 green:0.387 blue:0.812 alpha:1.000]];
		[_summaryTextLabel setTextColor:[NSColor colorWithCalibratedWhite:0.388 alpha:1.000]];
	}
}

@end
