//
//  JBArticleTableViewController.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBArticleTableViewController.h"
#import "JBArticle.h"
#import "JBMainArticleViewController.h"


@interface JBArticleTableViewController ()
- (NSArray *)articlesFromDisk;
- (void)startObservingArticle:(JBArticle *)newArticle;
- (void)forceSave;
@end


@implementation JBArticleTableViewController
@synthesize plusButton = _plusButton;
@synthesize popupButton = _popupButton;
@synthesize tableView = _tableView;
@synthesize arrayController = _arrayController;
@synthesize internalArrayOfArticles = _internalArrayOfArticles;
@synthesize mainArticleViewController = _mainArticleViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		self.internalArrayOfArticles = [NSMutableArray array];
    }
    
    return self;
}


- (void)awakeFromNib {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		NSArray *articles = [self articlesFromDisk];
		
		dispatch_sync(dispatch_get_main_queue(),^() {
			// Main Queue code
			
			for (id article in articles) {
				[self.arrayController addObject:article];
			}
			
			NSIndexSet *firstIndexSet = [NSIndexSet indexSetWithIndex:0];
			[[self tableView] selectRowIndexes:firstIndexSet byExtendingSelection:NO];
			
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewSelectionDidChange:) name:NSTableViewSelectionDidChangeNotification object:self.tableView];
		});
		
	});

}


- (void)saveAllArticles {
	[(NSArray *)[self.arrayController arrangedObjects] makeObjectsPerformSelector:@selector(saveIfNeeded)];
}


- (void)forceSave {
	[(NSArray *)[self.arrayController arrangedObjects] makeObjectsPerformSelector:@selector(forceSave)];
}


- (NSArray *)createdAtDateSorter {
	NSLog(@"Sorter?");
	return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"self.createdAtDate" ascending:NO]];
}


- (IBAction)plusButtonWasPressed:(NSButton *)sender {
}


- (void)addNewArticle:(id)sender {
	
	JBArticle *newArticle = [[JBArticle alloc] initNewArticle];
	
	[self startObservingArticle:newArticle];
	
	[[self arrayController] addObject:newArticle];
	
}


- (void)startObservingArticle:(JBArticle *)article {
	
	[article addObserver:self 
			  forKeyPath:@"headline" 
				 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
				 context:NULL];
	
	[article addObserver:self 
			  forKeyPath:@"source" 
				 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
				 context:NULL];
	
	[article addObserver:self 
			  forKeyPath:@"bodyText" 
				 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
				 context:NULL];
	
	[article addObserver:self 
			  forKeyPath:@"altText" 
				 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
				 context:NULL];
	
	[article addObserver:self 
			  forKeyPath:@"createdAtDate" 
				 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
				 context:NULL];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
	if ([object isKindOfClass:[JBArticle class]]) {
		//[(JBArticle *)object setUpdatedAtDate:[NSDate date]];
		[(JBArticle *)object setArticleUpdated:YES];
		NSLog(@"Got KVO notification for an Article, have marked it as updated and changed the time");
	}
}


- (NSArray *)articlesFromDisk {
	
	// Eventually this needs to be taken from the defaults for the currently selected website!
	NSString *articlesDirectoryPath = @"/Users/jbrennan/web/colophon/articles";
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	NSError *error = nil;
	NSArray *articlesInDirectory = [fileManager contentsOfDirectoryAtPath:articlesDirectoryPath error:&error];
	
	if (nil == articlesInDirectory) {
		NSLog(@"The articles directory path returned a nil array. Path: %@, Error: %@", articlesDirectoryPath, [error userInfo]);
		return nil;
	}
	
	
	// Get all the js files in the directory.
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self LIKE '*.js'"];
	NSArray *filteredArray = [articlesInDirectory filteredArrayUsingPredicate:predicate];
	
	[fileManager changeCurrentDirectoryPath:articlesDirectoryPath];
	
	NSMutableArray *articlesToReturn = [NSMutableArray arrayWithCapacity:[filteredArray count]];
	for (NSString *jsFileName in filteredArray) {
		NSError *fileReadingError = nil;
		NSData *jsFileData = [NSData dataWithContentsOfFile:jsFileName options:0 error:&fileReadingError];
		
		if (nil == jsFileData) {
			NSLog(@"There was an error reading in the data for js file: %@, Error: %@", jsFileName, [fileReadingError userInfo]);
		}
		
		NSError *jsParsingError = nil;
		NSDictionary *articleDictionary = [NSJSONSerialization JSONObjectWithData:jsFileData options:0 error:&jsParsingError];
		
		if (nil == articleDictionary) {
			NSLog(@"There was an error parsing the JS file into a dictionary. File: %@, Error: %@", jsFileName, [jsParsingError userInfo]);
		}
		
		
		// Create the article and give it the values read in from the JS file.
		JBArticle *readArticle = [[JBArticle alloc] init];
		readArticle.headline = [articleDictionary objectForKey:kHeadlineKey];
		readArticle.lede = [articleDictionary objectForKey:kLedeKey];
		readArticle.authorName = [articleDictionary objectForKey:kAuthorNameKey];
		readArticle.byLine = [articleDictionary objectForKey:kByLineKey];
		readArticle.altText = [articleDictionary objectForKey:kAltTextKey];
		readArticle.bodyFile = [articleDictionary objectForKey:kBodyFileKey];
		readArticle.bodyText = [NSString stringWithContentsOfFile:readArticle.bodyFile encoding:NSUTF8StringEncoding error:NULL];
		readArticle.metaFile = jsFileName;
		readArticle.sourceLink = [articleDictionary objectForKey:kSourceLinkKey];
		
		readArticle.createdAtDate = [NSDate dateWithTimeIntervalSince1970:[[articleDictionary objectForKey:kCreatedAtKey] doubleValue]];
		readArticle.updatedAtDate = [NSDate dateWithTimeIntervalSince1970:[[articleDictionary objectForKey:kUpdatedAtKey] doubleValue]];
		
		
		// Start observing the article?
		[self startObservingArticle:readArticle];
		
		// Add it to the array controller
		[articlesToReturn addObject:readArticle];
		
	}
	
	return articlesToReturn;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	[self.mainArticleViewController forcePreviewUpdate];
}


@end
