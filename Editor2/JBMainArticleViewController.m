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


@interface JBMainArticleViewController ()

- (void)textDidChange:(NSNotification *)notification;
- (void)requestPreviewUpdate;
- (void)preview:(id)object;

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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:_textView];
}


#pragma mark -
#pragma mark Text preview methods

// These methods, along with the NSString+Markdown Category are ripped almost verbatim from Steven Frank's Notational Velocity fork.
- (void)textDidChange:(NSNotification *)note {
	
	[self requestPreviewUpdate];
	
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
