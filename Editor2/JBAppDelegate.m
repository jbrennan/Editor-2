//
//  JBAppDelegate.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBAppDelegate.h"
#import "JBMainWindowController.h"
#import <dispatch/dispatch.h>


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


- (IBAction)publish:(NSMenuItem *)sender {
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		NSString *launchPath = @"/usr/bin/git";
		NSString *directoryPath = @"/Users/jbrennan/web/colophon/articles";//[[NSUserDefaults standardUserDefaults] stringForKey:@"articleDirectory"];
		
		NSTask *task;
		task = [[NSTask alloc] init];
		[task setLaunchPath:launchPath];
		[task setCurrentDirectoryPath:directoryPath];
		
		NSArray *arguments;
		arguments = [NSArray arrayWithObjects: @"add", @".", nil];
		[task setArguments: arguments];
		
		[task launch];
		[task waitUntilExit];
		
		NSTask *commitTask = [[NSTask alloc] init];
		[commitTask setLaunchPath:launchPath];
		[commitTask setCurrentDirectoryPath:directoryPath];
		
		[commitTask setArguments:[NSArray arrayWithObjects:@"commit", @"-m", @"Automatic publish by Editor 2.", nil]];
		
		[commitTask launch];
		[commitTask waitUntilExit];
		
		NSTask *pushTask = [[NSTask alloc] init];
		[pushTask setLaunchPath:launchPath];
		[pushTask setCurrentDirectoryPath:directoryPath];
		[pushTask setArguments:[NSArray arrayWithObjects:@"push", nil]];
		
		[pushTask launch];
		[pushTask waitUntilExit];
	});

	
	
}



@end
