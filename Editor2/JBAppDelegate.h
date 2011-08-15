//
//  JBAppDelegate.h
//  Editor2
//
//  Created by Jason Brennan on 11-08-12.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JBMainWindowController;
@interface JBAppDelegate : NSObject <NSApplicationDelegate>

@property (strong) IBOutlet NSWindow *window;
@property (nonatomic, strong) JBMainWindowController *mainWindowController;

@property (nonatomic, strong) NSString *info;


- (IBAction)setCurrentArticleAsSaved:(NSMenuItem *)sender;

@end
