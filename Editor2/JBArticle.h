//
//  JBArticle.h
//  Editor
//
//  Created by Jason Brennan on 10-04-28.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kHeadlineKey @"headline"
#define kLedeKey @"lede"
#define kAuthorNameKey @"author"
#define kByLineKey @"by_line"
#define kAltTextKey @"alt_text"
#define kBodyFileKey @"body_text" // not a bug!!
#define kSourceLinkKey @"source"
#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"

@interface JBArticle : NSObject {
	NSString *_headline;
	NSString *_lede;
	NSString *_byLine;
	NSString *_altText;
	NSString *_authorName;
	NSString *_authorEmail;
	NSString *_sourceLink;
	NSString *_bodyFile;
	NSString *_metaFile;
	NSDate *_createdAtDate;
	NSDate *_updatedAtDate;
	
	NSString *_bodyText;
	
	BOOL _articleUpdated;
	BOOL _canSave;
	
	
}

@property (nonatomic, copy) NSString *headline;
@property (nonatomic, copy) NSString *lede;
@property (nonatomic, copy) NSString *byLine;
@property (nonatomic, copy) NSString *altText;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *authorEmail;
@property (nonatomic, copy) NSString *sourceLink;
@property (nonatomic, copy) NSString *bodyFile;
@property (nonatomic, copy) NSString *metaFile;
@property (nonatomic, retain) NSDate *createdAtDate;
@property (nonatomic, retain) NSDate *updatedAtDate;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, getter=isArticleUpdated) BOOL articleUpdated;
@property (nonatomic, readonly) NSString *bunchedUpBodyText; // Extra newlines stripped out for display in the table cells.
@property (nonatomic, readonly) NSUInteger wordCount;
@property (nonatomic, assign) BOOL canSave;						// Used so auto-save doesn't try to save an article before I've decided on its headline.
@property (copy) NSString *computedPermalink;					// Either read in from file, or from the network.


- (id)initNewArticle;
- (void)saveIfNeeded;
- (void)forceSave;

@end
