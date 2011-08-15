//
//  JBMainWindowController.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBMainWindowController.h"
#import "JBArticleTableViewController.h"
#import "JBSplitView.h"
#import "NSSplitView+Utilities.h"
#import "JBMainArticleViewController.h"


@implementation JBMainWindowController
@synthesize splitView = _splitView;
@synthesize articleTableViewController = _articleTableViewController;
@synthesize mainArticleViewController = _mainArticleViewController;
@synthesize infoLabel = _infoLabel;


- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
	
	self.articleTableViewController = [[JBArticleTableViewController alloc] initWithNibName:@"JBArticleTableViewController" bundle:nil];
	self.mainArticleViewController = [[JBMainArticleViewController alloc] initWithNibName:@"JBMainArticleViewController" bundle:nil];
	
	self.articleTableViewController.mainArticleViewController = self.mainArticleViewController;
	self.mainArticleViewController.articleTableViewController = self.articleTableViewController;
	
	self.splitView.leftView = [[self articleTableViewController] view];
	self.splitView.rightView = [[self mainArticleViewController] view];
	
	[[self infoLabel] setStringValue:@"loaded"];
}

- (IBAction)addButtonWasPressed:(NSButton *)sender {
	
	[[self articleTableViewController] addNewArticle:sender];
	
}


- (void)setCurrentArticleAsSaved {
	[[self mainArticleViewController] setCurrentArticleAsSaved];
}



@end
