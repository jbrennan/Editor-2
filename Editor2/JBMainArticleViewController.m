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


@implementation JBMainArticleViewController
@synthesize splitView = _splitView;
@synthesize textView = _textView;
@synthesize webView = _webView;
@synthesize sourceTextField = _sourceTextField;
@synthesize headlineTextField = _headlineTextField;
@synthesize altTextField = _altTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



@end
