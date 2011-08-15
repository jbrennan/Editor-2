//
//  JBMainArticleViewController.h
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JBSplitView;
@class JBArticleTableViewController;
@interface JBMainArticleViewController : NSViewController {
	JBSplitView *_splitView;
	NSTextView *_textView;
	WebView *_webView;
	NSTextField *_sourceTextField;
	NSTextField *_headlineTextField;
	NSTextField *_altTextField;
}

@property (strong) IBOutlet JBSplitView *splitView;
@property (strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet WebView *webView;
@property (strong) IBOutlet NSTextField *sourceTextField;
@property (strong) IBOutlet NSTextField *headlineTextField;
@property (strong) IBOutlet NSTextField *altTextField;
@property (nonatomic, unsafe_unretained) JBArticleTableViewController *articleTableViewController;

- (void)addNewArticle:(id)sender;

@end
