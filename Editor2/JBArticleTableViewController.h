//
//  JBArticleTableViewController.h
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JBMainArticleViewController;
@interface JBArticleTableViewController : NSViewController {
	NSButton *_plusButton;
	NSPopUpButton *_popupButton;
	NSTableView *_tableView;
	NSArrayController *_arrayController;
}


@property (strong) IBOutlet NSButton *plusButton;
@property (strong) IBOutlet NSPopUpButton *popupButton;
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (nonatomic, strong) NSMutableArray *internalArrayOfArticles;
@property (nonatomic, readonly) NSArray *createdAtDateSorter;
@property (nonatomic, strong) JBMainArticleViewController *mainArticleViewController;

- (IBAction)plusButtonWasPressed:(NSButton *)sender;


@end
