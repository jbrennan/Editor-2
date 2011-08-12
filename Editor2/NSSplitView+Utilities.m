//
//  NSSplitView+Utilities.m
//  Bugs
//
//  Created by Jason Brennan on 09-11-21.
//  Copyright 2009 Jason Brennan. All rights reserved.
//

#import "NSSplitView+Utilities.h"


@implementation NSSplitView (Utilities)

- (NSView *)rightView {
	return [[self subviews] objectAtIndex:1];
}


- (void)setRightView:(NSView *)aView {
	NSRect oldFrame = [[self rightView] frame];
	[aView setFrame:oldFrame];
	[self replaceSubview:[self rightView] with:aView];
}


- (NSView *)leftView {
	return [[self subviews] objectAtIndex:0];
}


- (void)setLeftView:(NSView *)aView {
	NSRect oldFrame = [[self leftView] frame];
	[aView setFrame:oldFrame];
	[self replaceSubview:[self leftView] with:aView];
}

@end
