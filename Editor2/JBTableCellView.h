//
//  JBTableCellView.h
//  Editor2
//
//  Created by Jason Brennan on 11-08-15.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface JBTableCellView : NSTableCellView

@property (nonatomic, strong) IBOutlet NSTextField *titleTextLabel;
@property (nonatomic, strong) IBOutlet NSTextField *dateTextLabel;
@property (nonatomic, strong) IBOutlet NSTextField *summaryTextLabel;

@end
