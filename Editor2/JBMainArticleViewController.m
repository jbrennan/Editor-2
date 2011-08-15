//
//  JBMainArticleViewController.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBMainArticleViewController.h"
#import "JBSplitView.h"
#import "NSSplitView+Utilities.h"
#import "NSString+Markdown.h"
#import "JBArticleTableViewController.h"
#import "JBAppDelegate.h"
#import <dispatch/dispatch.h>
#import "JBArticle.h"


@interface JBMainArticleViewController ()

- (void)textDidChange:(NSNotification *)notification;
- (void)requestPreviewUpdate;
- (void)requestAutoSave;
- (void)preview:(id)object;
//- (void)startObservingArticle:(JBArticle *)article;

@end


@implementation JBMainArticleViewController
@synthesize splitView = _splitView;
@synthesize textView = _textView;
@synthesize webView = _webView;
@synthesize sourceTextField = _sourceTextField;
@synthesize headlineTextField = _headlineTextField;
@synthesize altTextField = _altTextField;
@synthesize articleTableViewController = _articleTableViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)awakeFromNib {
	
	NSURL *address = [NSURL URLWithString:@"http://vernacularoracular.com"];
	NSURLRequest *request = [NSURLRequest requestWithURL:address];
	
	[[self.webView mainFrame] loadRequest:request];
	
	[self requestPreviewUpdate];
	[self requestAutoSave];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:_textView];
}


- (void)setCurrentArticleAsSaved {
	JBArticle *currentArticle = [self.articleTableViewController.arrayController selection];
	
	if (nil == currentArticle) {
		NSLog(@"Tried to save current article, but there was non selected. Beep!");
		NSBeep();
		return;
	}
	
	[currentArticle setCanSave:YES];
}


- (void)requestAutoSave {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autosave:) object:nil];
	
	[self performSelector:@selector(autosave:) withObject:nil afterDelay:4];
}


- (void)autosave:(id)object {
	NSLog(@"Autosave!");
	
	[(JBAppDelegate *)[[NSApplication sharedApplication] delegate] setInfo:@"Saving..."];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		// Do the save
		for (int i = 0; i < 10000; i++) {
			NSString *s = [[NSString alloc] initWithString:@"blah"];
			NSLog(@"%@", s);
		}
		
		// update the label on the main queue
		dispatch_queue_t mainQueue = dispatch_get_main_queue();
		dispatch_async(mainQueue, ^() {
			[(JBAppDelegate *)[[NSApplication sharedApplication] delegate] setInfo:@"Saved!"];
		});
		
	});
	
}


#pragma mark -
#pragma mark Text preview methods

// These methods, along with the NSString+Markdown Category are ripped almost verbatim from Steven Frank's Notational Velocity fork.
- (void)textDidChange:(NSNotification *)note {
	
	[self requestPreviewUpdate];
	[self requestAutoSave];
	
}


- (void)requestPreviewUpdate {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preview:) object:nil];
	
	[self performSelector:@selector(preview:) withObject:nil afterDelay:0.5];
}


- (void)preview:(id)object {
	NSString *markdownString = [NSString stringByProcessingMarkdown:[_textView string]];
	
	[[_webView mainFrame] loadHTMLString:markdownString baseURL:nil];
}


@end
