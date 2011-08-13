//
//  JBArticleTableViewController.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBArticleTableViewController.h"

@implementation JBArticleTableViewController
@synthesize plusButton = _plusButton;
@synthesize popupButton = _popupButton;
@synthesize tableView = _tableView;
@synthesize arrayController = _arrayController;
@synthesize internalArrayOfArticles = _internalArrayOfArticles;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		self.internalArrayOfArticles = [NSMutableArray array];
    }
    
    return self;
}

- (IBAction)plusButtonWasPressed:(NSButton *)sender {
}
@end
