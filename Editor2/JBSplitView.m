//
//  JBSplitView.m
//  Bugs
//
//  Created by Jason Brennan on 09-11-30.
//  Copyright 2009 Jason Brennan. All rights reserved.
//

#import "JBSplitView.h"
#import "NSSplitView+Utilities.h"

@implementation JBSplitView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		[self setDelegate:self];
    }
    return self;
}





- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self setDelegate:self];
	
}

- (NSColor *)dividerColor {
	return [NSColor colorWithCalibratedRed:0.250 green:0.250 blue:0.250 alpha:1.000];
}


- (CGFloat)dividerThickness {
	return 0.2f;
}


#pragma mark -
#pragma mark Delegate Methods

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview {
	return [subview isEqual:self.rightView];
}

@end
