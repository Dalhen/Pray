//
//  KeyValuePairReader.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSDictionary+KeyValuePair.h"


@implementation NSDictionary (KeyValuePair)

+ (NSDictionary *) dictionaryFromKeyValuePairUrl:(NSString *)url {
	NSError *error = nil;
	
	NSString *contents = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
	NSString *formatted = [contents stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	
	NSArray *lines = [formatted componentsSeparatedByString:@"\n"];
	
	NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:0];
	NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:0];
	
	for(NSString *line in lines) {
		NSArray *value = [line componentsSeparatedByString:@"="];
		[keys addObject:[value objectAtIndex:0]];
		[objects addObject:[value objectAtIndex:1]];
	}
	
	NSDictionary *result = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	
	return result;
}

@end
