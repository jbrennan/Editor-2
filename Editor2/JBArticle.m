//
//  JBArticle.m
//  Editor
//
//  Created by Jason Brennan on 10-04-28.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import "JBArticle.h"


@interface JBArticle ()
- (NSString *)slugForHeadline:(NSString *)headline;
@end


@implementation JBArticle
@synthesize headline = _headline;
@synthesize lede = _lede;
@synthesize byLine = _byLine;
@synthesize altText = _altText;
@synthesize authorName = _authorName;
@synthesize authorEmail = _authorEmail;
@synthesize sourceLink = _sourceLink;
@synthesize bodyFile = _bodyFile;
@synthesize metaFile = _metaFile;
@synthesize createdAtDate = _createdAtDate;
@synthesize updatedAtDate = _updatedAtDate;
@synthesize bodyText = _bodyText;
@synthesize articleUpdated = _articleUpdated;
@synthesize canSave = _canSave;
@synthesize computedPermalink = _computedPermalink;


#pragma mark -
#pragma mark Object Lifecycle

// For when an article is read off disk
- (id)init {
	if (self = [super init]) {
		_articleUpdated = NO;
		_canSave = YES; // An article read in from disk is savable, because it's already been saved previously.
	}
	
	return self;
}


- (NSString *)bunchedUpBodyText {
	return [self.bodyText stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
}


- (NSUInteger)wordCount {
	return [[self.bodyText componentsSeparatedByString:@" "] count];
}


// For when a new article is created from the interface
- (id)initNewArticle {
	if (self = [super init]) {
		_articleUpdated = YES;
		_canSave = NO; // brand new article cannot be saved until I've designated it specifically.
		self.createdAtDate = [NSDate date];
		self.updatedAtDate = [NSDate date];
	}
	
	return self;
}




// Shouldn't have a need to call this, but leaving it in just in case I need it.
- (void)forceSave {
	_articleUpdated = YES;
	_canSave = YES;
	[self saveIfNeeded];
}


- (void)saveIfNeeded {
	
	// Don't need to save. Fail
	if (!_articleUpdated)
		return;
	
	
	// Haven't settled on a headline yet.
	if (!_canSave)
		return;
	
	// Create a filename and filePath for the markdown/body text
	
	NSString *bodyFileName = self.bodyFile;
	
	if (nil == bodyFileName) {
		bodyFileName = [[self slugForHeadline:self.headline] stringByAppendingString:@".md"];
	}
	
	NSString *directoryPath = @"/Users/jbrennan/web/colophon/articles/";//[[[NSUserDefaults standardUserDefaults] stringForKey:@"articleDirectory"] stringByAppendingString:@"/"];
	NSString *bodyFilePath = [directoryPath stringByAppendingString:bodyFileName];
	
	// Save the body text out to the markdown file
	NSError *bodyFileError = nil;
	if (![self.bodyText writeToFile:bodyFilePath atomically:YES encoding:NSUTF8StringEncoding error:&bodyFileError]) {
		NSLog(@"There was an error writing the article's body to the markdown file. Headline: %@, Error: %@", self.headline, [bodyFileError localizedDescription]);
		return;
	}
	
	
	// The JS filename and path
	NSString *jsFileName = self.metaFile;
	if (nil == jsFileName) {
		jsFileName = [[self slugForHeadline:self.headline] stringByAppendingString:@".js"];
	}
	
	NSString *jsFilePath = [directoryPath stringByAppendingString:jsFileName];
	
	// Create the Dictionary
	NSMutableDictionary *articleDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
	[articleDictionary setObject:self.headline ? self.headline : @"" forKey:kHeadlineKey];
	[articleDictionary setObject:self.lede ? self.lede : @"" forKey:kLedeKey];
	[articleDictionary setObject:self.byLine ? self.byLine : @"" forKey:kByLineKey];
	[articleDictionary setObject:self.altText ? self.altText : @"" forKey:kAltTextKey];
	[articleDictionary setObject:self.authorName ? self.authorName : @"" forKey:kAuthorNameKey];
	//[articleDictionary setObject:self.authorEmail forKey:kAuthorEmailKey];
	[articleDictionary setObject:self.sourceLink ? self.sourceLink : @"self" forKey:kSourceLinkKey];
	
	
	// Format the dates so they may be saved as a string
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
	
	//NSString *createdAtString = [//[[dateFormatter stringFromDate:self.createdAtDate] stringByReplacingOccurrencesOfString:@"," withString:@""];
	//NSString *updatedAtString = [[dateFormatter stringFromDate:self.updatedAtDate] stringByReplacingOccurrencesOfString:@"," withString:@""];
	
	NSNumber *createdAtNumber = [NSNumber numberWithDouble:[self.createdAtDate timeIntervalSince1970]];
	NSNumber *updatedAtNumber = [NSNumber numberWithDouble:[self.updatedAtDate timeIntervalSince1970]];
	

	
	[articleDictionary setObject:createdAtNumber ? createdAtNumber : @"" forKey:kCreatedAtKey];
	[articleDictionary setObject:updatedAtNumber ? updatedAtNumber : @"" forKey:kUpdatedAtKey];
	[articleDictionary setObject:bodyFileName ? bodyFileName : @"" forKey:kBodyFileKey];
	
	
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:articleDictionary options:NSJSONWritingPrettyPrinted error:&error];
	if (nil == jsonData) {
		NSLog(@"There was an error transforming the articleDictionary to JSON data. Error: %@", [error localizedDescription]);
	}
	
	
	NSError *jsonFileError = nil;
	if (![jsonData writeToFile:jsFilePath options:NSDataWritingAtomic error:&jsonFileError]) {
		NSLog(@"There was an error writing the JS file to disk. Headline: %@, error: %@", self.headline, [jsonFileError localizedDescription]);
		return;
	}
	
	
	_articleUpdated = NO; // because we've saved, now the article can again be changed so we must track that
}


- (NSString *)slugForHeadline:(NSString *)headline {
	
	if ([self.computedPermalink length] > 0)
		return self.computedPermalink;
	
	NSString *escapedString = [headline stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *URLString = [NSString stringWithFormat:@"http://nearthespeedoflight.com/api/colophon.slug/%@", escapedString];
	
	// This is a blocking call, but this method is executed off the main queue, so it won't block the UI.
	NSError *error = nil;
	NSLog(@"About to fetch a permalink for headline: %@", headline);
	self.computedPermalink = [NSString stringWithContentsOfURL:[NSURL URLWithString:URLString] encoding:NSUTF8StringEncoding error:&error];
	
	if (nil == self.computedPermalink) {
		NSLog(@"There was an error trying to get the slug for headline: %@, error: %@", headline, [error userInfo]);
		self.computedPermalink = [[[[headline stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByReplacingOccurrencesOfString:@"?" withString:@"_"] stringByReplacingOccurrencesOfString:@"\"" withString:@"_"] stringByReplacingOccurrencesOfString:@"'" withString:@"_"];
	}
	
	return self.computedPermalink;
}


#pragma mark -
#pragma mark Custom accessors


- (void)setArticleUpdated:(BOOL)isUpdated {
	_articleUpdated = isUpdated;
	
	if (isUpdated) {
		[self setUpdatedAtDate:[NSDate date]];
	}
}

//- (void)setHeadline:(NSString *)newHeadline {
//	if ([_headline isEqualToString:newHeadline])
//		return;
//	
//	if (nil != _headline || nil != newHeadline)
//		_articleUpdated = YES;
//	
//		
//}



@end
