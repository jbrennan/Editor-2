//
//  NSString+Markdown.h
//  Editor2
//
//  Created by Jason Brennan on 11-08-13.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Markdown)

+ (NSString *)stringByProcessingMarkdown:(NSString *)markdown;

@end
