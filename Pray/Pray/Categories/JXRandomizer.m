//
//  Randomizer.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "JXRandomizer.h"

/*-----------------------------------------------------------------------------------------------------*/

#define ARC4RANDOM_MAX      0x100000000

/*-----------------------------------------------------------------------------------------------------*/

@implementation JXRandomizer

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - intergers
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (int) randomInt 
{
    return abs(arc4random());
}

+ (int) randomIntWithLimit: (int)limitInt 
{
    if (limitInt < 0) 
        {
        return -([self randomInt] % (-limitInt+1));
        }
        
    return [self randomInt] % (limitInt+1);    
}

+ (int) randomIntBetweenMinInt: (int)minInt 
                     andMaxInt: (int)maxInt 
{
    if (maxInt < minInt) 
        {
        printImportant(@"You cannot generate a random int between minimum int: %d and maximum int: %d", minInt, maxInt);
        return 0;
        }

    return ([self randomInt] % (maxInt-minInt+1)) + minInt;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - doubles
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (double) randomDouble 
{
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

+ (double) randomDoubleWithLimit: (double)limitDouble; 
{
    return [self randomDouble] * limitDouble;
}

+ (double) randomDoubleBetweenMinDouble: (double)minDouble 
                           andMaxDouble: (double)maxDouble 
{
    if (maxDouble < minDouble) 
        {
        printImportant(@"You cannot generate a random double between minimum double: %F and maximum double: %F", minDouble, maxDouble);
        return 0.0;
        }
    
    return ([self randomDouble] * (maxDouble-minDouble)) + minDouble;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - strings
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *) randomNumericStringOfLength: (unsigned int)length 
{
    return [self randomStringOfLength:length 
              usingCharactersInString:@"0123456789"];
    
}

+ (NSString *) randomAlphabeticalStringOfLength: (unsigned int)length 
{
    return [self randomStringOfLength:length 
              usingCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    
}

+ (NSString *) randomAlphaNumericStringOfLength: (unsigned int)length 
{
    return [self randomStringOfLength:length 
              usingCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
}


+ (NSString *) randomStringOfLength: (unsigned int)length 
            usingCharactersInString: (NSString *)characterString 
{
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < length; i++) 
        {
        int randomCharPosition = [self randomIntWithLimit:(int)[characterString length]-1];
        [resultString appendFormat:@"%c", [characterString characterAtIndex:randomCharPosition]];
        }
    
    return resultString;
}


@end
