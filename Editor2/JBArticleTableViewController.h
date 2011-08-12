//
//  JBArticleTableViewController.h
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JBArticleTableViewController : NSViewController {
	NSButton *_plusButton;
	NSPopUpButton *_popupButton;
	NSTableView *_tableView;
}

@property (strong) IBOutlet NSButton *plusButton;
@property (strong) IBOutlet NSPopUpButton *popupButton;
@property (strong) IBOutlet NSTableView *tableView;

@end
