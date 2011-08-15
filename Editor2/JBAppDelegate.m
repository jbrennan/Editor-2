//
//  JBAppDelegate.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBAppDelegate.h"
#import "JBMainWindowController.h"


@implementation JBAppDelegate

@synthesize window = _window;
@synthesize mainWindowController = _mainWindowController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.mainWindowController = [[JBMainWindowController alloc] initWithWindowNibName:@"JBMainWindow"];
	
	[[self.mainWindowController window] makeKeyAndOrderFront:self];
}


- (void)applicationDidResignActive:(NSNotification *)notification {
	NSLog(@"Resign active");
}


- (void)setInfo:(NSString *)info {
	[self.mainWindowController.infoLabel setStringValue:info];
}


- (NSString *)info {
	return [self.mainWindowController.infoLabel stringValue];
}

- (IBAction)setCurrentArticleAsSaved:(NSMenuItem *)sender {
	
	[self.mainWindowController setCurrentArticleAsSaved];
}

@end
