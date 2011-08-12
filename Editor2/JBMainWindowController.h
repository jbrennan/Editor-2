//
//  JBMainWindowController.h
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JBMainWindowController : NSWindowController {
	NSSplitView *_splitView;
}


@property (strong) IBOutlet NSSplitView *splitView;
@end
