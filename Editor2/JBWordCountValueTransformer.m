//
//  JBWordCountValueTransformer.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-14.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBWordCountValueTransformer.h"

@implementation JBWordCountValueTransformer


+ (Class)transformedValueClass { 
	return [NSString class];
}


+ (BOOL)allowsReverseTransformation {
	return NO;
}


- (id)transformedValue:(id)value {
	if (nil == value) return nil;
	
	NSUInteger num = [(NSNumber *)value unsignedIntegerValue];
	
    return [NSString stringWithFormat:@"%d word%@", num, num == 1 ? @"" : @"s"];
}


@end
