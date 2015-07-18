//
//  NSMutableArray+StringSerialiser.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSMutableArray+StringSerialiser.h"


@implementation NSMutableArray (StringSerialiser)

- (NSString *) stringValue {
	NSMutableString *valueString = [[NSMutableString alloc] init];
	
	for(NSString *value in self) {
		[valueString appendFormat:@"%@|", value];
	}
	
	return valueString;
}

+ (NSMutableArray *) fromStringValue:(NSString *)string {
	NSMutableArray *items = [[NSMutableArray alloc] init];	
	NSMutableArray *elements = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@"|"]];
	[elements removeLastObject];
	
	for(NSString *element in elements) {
		[items addObject:element];
	}
	
	
	return items;
}

@end
