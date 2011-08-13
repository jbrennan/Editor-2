//
//  NSString+Markdown.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-13.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "NSString+Markdown.h"

@implementation NSString (Markdown)


+ (NSString *)stringByProcessingMarkdown:(NSString *)markdown {
	NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"Markdown" ofType:@"pl"];
	
	NSTask *task = [[NSTask alloc] init];
	NSMutableArray *arguments = [NSMutableArray array];
	
	[arguments addObject:scriptPath];
	[task setArguments:arguments];
	
	
	NSPipe *stdinPipe = [NSPipe pipe];
	NSPipe *stdOutPipe = [NSPipe pipe];
	NSFileHandle *stdinFileHandle = [stdinPipe fileHandleForWriting];
	NSFileHandle *stdoutFileHandle = [stdOutPipe fileHandleForReading];
	
	[task setStandardInput:stdinPipe];
	[task setStandardOutput:stdOutPipe];
	
	[task setLaunchPath:@"/usr/bin/perl"];
	[task launch];
	
	[stdinFileHandle writeData:[markdown dataUsingEncoding:NSUTF8StringEncoding]];
	[stdinFileHandle closeFile];
	
	NSData *outputData = [stdoutFileHandle readDataToEndOfFile];
	NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
	[stdoutFileHandle closeFile];
	
	[task waitUntilExit];
	
	return outputString;
}


@end
