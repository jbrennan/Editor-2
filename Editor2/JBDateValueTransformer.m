//
//  JBDateValueTransformer.m
//  Editor2
//
//  Created by Jason Brennan on 11-08-15.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBDateValueTransformer.h"

@implementation JBDateValueTransformer


+ (Class)transformedValueClass { 
	return [NSString class];
}


+ (BOOL)allowsReverseTransformation {
	return NO;
}


- (id)transformedValue:(id)value {
	
	if (nil == value) return nil;
	if (![value isKindOfClass:[NSDate class]]) return nil;
	
	
	
	NSCalendarDate *inDate = value;
	if(![value isKindOfClass: [NSCalendarDate class]])
		inDate = [value dateWithCalendarFormat:nil timeZone:nil];
	
//	NSUserDefaults *theDefault=[NSUserDefaults standardUserDefaults];
	NSInteger today = [[NSCalendarDate calendarDate]dayOfCommonEra];
	NSInteger dateDay = [inDate dayOfCommonEra];
	
	
	if(dateDay==today)
		return @"Today";
				
	if(dateDay==(today+1))
		return @"Tomorrow";
				
	if(dateDay==(today-1))
		return @"Yesterday";
				
	return [super transformedValue:value];
}


@end
