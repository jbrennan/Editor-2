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


@implementation JBMainArticleViewController {
	BOOL _saving;
}
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

	
	[[[self webView] preferences] setDefaultFontSize:16];
	[[[self webView] preferences] setDefaultFixedFontSize:13];
	
	
	[[self textView] setFont:[NSFont fontWithName:@"Menlo" size:12.0f]];
	[[self textView] setTextContainerInset:CGSizeMake(20.0f, 20.0f)];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:_textView];
}


- (void)setCurrentArticleAsSaved {
	id currentArticle = [self.articleTableViewController.arrayController selection];
	
	if (nil == currentArticle) {
		NSLog(@"Tried to save current article, but there was non selected. Beep!");
		NSBeep();
		return;
	}
	
	// currentArticle is really just a proxy object
	// it doesn't have methods, but it's fully KVC compliant.
	[currentArticle setValue:[NSNumber numberWithBool:YES] forKey:@"canSave"];
	[self requestAutoSave];
}


- (void)requestAutoSave {
	[(JBAppDelegate *)[[NSApplication sharedApplication] delegate] setInfo:@"edited"];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autosave:) object:nil];
	
	[self performSelector:@selector(autosave:) withObject:nil afterDelay:4];
}


- (void)autosave:(id)object {
	NSLog(@"Autosave!");
	
	if (_saving) return;
	
	_saving = YES;
	
	[(JBAppDelegate *)[[NSApplication sharedApplication] delegate] setInfo:@"saving"];
	
	
	// Set the current article's bodyText to have the textView's string value.
	id currentArticle = [self.articleTableViewController.arrayController selection];
	
	
	// currentArticle is really just a proxy object
	// it doesn't have methods, but it's fully KVC compliant.
	[currentArticle setValue:[_textView string] forKey:@"bodyText"];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		// Do the save
		[self.articleTableViewController saveAllArticles];
		
		// update the label on the main queue
		dispatch_queue_t mainQueue = dispatch_get_main_queue();
		dispatch_async(mainQueue, ^() {
			[(JBAppDelegate *)[[NSApplication sharedApplication] delegate] setInfo:@"saved"];
			_saving = NO;
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


- (void)forcePreviewUpdate {
	[self performSelector:@selector(preview:) withObject:nil afterDelay:0];
}


- (void)preview:(id)object {
	NSString *markdownString = [NSString stringByProcessingMarkdown:[_textView string]];
	
	[[_webView mainFrame] loadHTMLString:markdownString baseURL:nil];

}


@end
