//
//  JBMainWindowController.h
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JBSplitView;
@class JBArticleTableViewController;
@interface JBMainWindowController : NSWindowController {
	JBSplitView *_splitView;
	JBArticleTableViewController *_articleTableViewController;
}


@property (strong) IBOutlet JBSplitView *splitView;
@property (nonatomic, strong) JBArticleTableViewController *articleTableViewController;

@end
