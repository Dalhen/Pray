//
//  CMLogger.m
//  CMLogger
//
//  Created by Jason LAPIERRE on 15/10/2012.
//  Copyright (c) 2012 Jason LAPIERRE a.k.a. The One Man Corporation. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "CMLogger.h"
#import "CMLoggerConfiguration.h"
#import "CMPrivateLoggerCalls.h"
#import "CMLoggerCategoryExtensions.h"

/*-----------------------------------------------------------------------------------------------------*/

@interface CMLogger ()
@property (nonatomic, unsafe_unretained) short int currentCallingMethodLength;
@property (nonatomic, unsafe_unretained) unsigned long long int currentLineNumber;
@property (nonatomic, strong) NSString *currentLoggingClass;
@property (nonatomic, strong) NSString *currentLoggingMethod;
@property (nonatomic, strong) NSString *currentLoggingVariable;

@end

/*-----------------------------------------------------------------------------------------------------*/

@implementation CMLogger

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - printing control
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)willStartLoggerSessionWithMethod:(NSString *)methodName
                           inLineNumber:(unsigned long long int)lineNumber
                              fromClass:(NSString *)className
{
    self.currentLoggingClass = className;
    self.currentLineNumber = lineNumber;
    self.currentLoggingMethod = methodName;
}

-(void)willStartLoggerSessionWithMethod:(NSString *)methodName
                           inLineNumber:(unsigned long long int)lineNumber
                          usingVariable:(char *)variableName
                              fromClass:(NSString *)className
{
    self.currentLoggingClass = className;
    self.currentLineNumber = lineNumber;
    self.currentLoggingMethod = methodName;
    self.currentLoggingVariable = [NSString stringWithCString:variableName encoding:NSStringEncodingConversionAllowLossy];
}

-(void)didEndLoggingSession
{
    self.currentCallingMethodLength = -1;
}

- (BOOL)shouldPrintForType:(kPrintType)type
{
    if (kCMLogger_ShouldLog)
    {
        for (NSString *value in kCMLogger_ExcludedClasses)
        {
            if ([self.currentLoggingClass isEqualToString:value])
            {
                return NO;
            }
        }
        switch (type) {
            case kPrintWorkflow:
                return kCMLogger_ShouldLogWorkflowLevel;
                break;
            case kPrintDeveloper:
                return kCMLogger_ShouldLogDeveloperLevel;
                break;
            case kPrintCritical:
                return kCMLogger_ShouldLogCriticalLevel;
                break;
        }
    }
    return NO;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - base utilities
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)newLineHeader
{
    if (kCMLogger_ShouldLogCallingMethod)
    {
        if (self.currentCallingMethodLength == -1)
        {
            NSString *printString = [NSString stringWithFormat:@"%@.%@|%lld| ", self.currentLoggingClass, self.currentLoggingMethod, self.currentLineNumber];
            self.currentCallingMethodLength = (short int)printString.length;
            return printString;
        }
        
        NSMutableString *spaceString = [NSMutableString string];
        for (short int i = 0; i < self.currentCallingMethodLength; i++)
        {
            [spaceString appendString:@" "];
        }
        return spaceString;
        
    }
    return @"";
}

-(NSString *)getValidSuperclassNameOfClass:(Class)class
{
    return [self getValidClassName:[class superclass]];
}

-(NSString *)getValidClassName:(Class)class
{
    NSString *className = NSStringFromClass(class);
    if ([className hasPrefix:@"_"])
    {
        return [self getValidClassName: [class superclass]];
    }
    return className;
}

-(NSString *)recursiveObjectClasses: (Class)class
            withStartingIndentSpace: (unsigned int)n
{   /* this utitility method is used to print out the inheritance stack on an object */
    NSMutableString *outputString = [NSMutableString stringWithString:[self newLineHeader]];
    if (n > 0)
    {
        for (int i = 0; i < n; i++)
        {
            [outputString appendFormat:@"    "];
        }
    }
    
    NSString *currentClassName = [self getValidClassName:class];
    [outputString appendFormat:@"-> %@\n", currentClassName];
    
    if (![class superclass])
    {
        return outputString;
    }
    
    //continue until entire hierarchy is printed
    n++;
    return [outputString stringByAppendingString:[self recursiveObjectClasses:NSClassFromString([self getValidSuperclassNameOfClass:NSClassFromString(currentClassName)])
                                                      withStartingIndentSpace:n]];
}

-(NSString *)recursiveViewSubviews: (UIView *)view
           withStartingIndentSpace: (unsigned int)n
{   /* this utitility method is used to print out the superview stack on an view object */
    int count = 0;
    NSMutableString *outputString = [NSMutableString string];
    for (UIView *subview in [view subviews])
    {
        [outputString appendString:[self newLineHeader]];
        if (n > 0)
        {
            for (int i = 0; i < n; i++)
            {
                [outputString appendFormat:@"    "];
            }
        }
        
        CGRect frame = subview.frame;
        [outputString appendFormat:@"%u ->  %@ ( %.0f, %.0f, %.0f, %.0f )\n", count, [self getValidClassName:[subview class]], frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
        
        count++;
        
        //continue until entire hierarchy is printed
        if (subview.subviews.count > 0)
        {
            [outputString appendString:[self recursiveViewSubviews:subview
                                           withStartingIndentSpace:n+1]];
        }
    }
    return outputString;
}

-(NSString *)recursiveViewSuperviews: (UIView *)view
             withStartingIndentSpace: (unsigned int)n
{   /* this utitility method is used to print out the superview stack on an view object */
    NSMutableString *outputString = [NSMutableString stringWithString:[self newLineHeader]];
    if (n > 0)
    {
        for (int i = 0; i < n; i++)
        {
            [outputString appendFormat:@"    "];
        }
    }
    
    CGRect frame = view.superview.frame;
    [outputString appendFormat:@"->  %@ ( %.0f, %.0f, %.0f, %.0f )\n", [self getValidClassName:[view.superview class]], frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
    
    if (![[view superview] superview])
    {
        return outputString;
    }
    
    //continue until entire hierarchy is printed
    n++;
    return [outputString stringByAppendingString:[self recursiveViewSuperviews:view.superview
                                                       withStartingIndentSpace:n]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - developer
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logError:(NSError *)error
{
    if ([self shouldPrintForType:kPrintCritical])
    {
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@*********************************************\n%@ERROR >>> %@::", newLineHeader, newLineSpacing, self.currentLoggingVariable];
        [outputString appendString: [error logDescriptionWithSpacing:newLineSpacing]];
        [outputString appendFormat:@"%@*********************************************\n", newLineSpacing];
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logFailPt
{
    if ([self shouldPrintForType:kPrintCritical])
    {
        printf("%s*** FAIL:: code should never reach this point.\n", [[self newLineHeader] UTF8String]);
    }
}

-(void)logFail: (NSString *)failMsg, ...
{
    if ([self shouldPrintForType:kPrintCritical])
    {
        va_list args;
        va_start(args, failMsg);
        NSString *print=[[NSString alloc] initWithFormat:failMsg arguments:args];
        va_end(args);
        printf("%s*** FAIL:: %s\n", [[self newLineHeader] UTF8String], [print UTF8String]);
    }
}

-(void)logNote: (NSString *)noteMsg, ...
{
    if ([self shouldPrintForType:kPrintDeveloper])
    {
        va_list args;
        va_start(args, noteMsg);
        NSString *print=[[NSString alloc] initWithFormat:noteMsg arguments:args];
        va_end(args);
        printf("%s>>> NOTE:: %s\n", [[self newLineHeader] UTF8String], [print UTF8String]);
    }
}

-(void)logTodoPt
{
    if ([self shouldPrintForType:kPrintDeveloper])
    {
        printf("%s>>> TODO:: code needs to be implemented.\n", [[self newLineHeader] UTF8String]);
    }
}

-(void)logTodo: (NSString *)todoMsg, ...
{
    if ([self shouldPrintForType:kPrintDeveloper])
    {
        va_list args;
        va_start(args, todoMsg);
        NSString *print=[[NSString alloc] initWithFormat:todoMsg arguments:args];
        va_end(args);
        printf("%s>>> TODO:: %s\n", [[self newLineHeader] UTF8String], [print UTF8String]);
    }
}

-(void)log: (NSString *)msg, ...
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        va_list args;
        va_start(args, msg);
        NSString *print=[[NSString alloc] initWithFormat:msg arguments:args];
        va_end(args);
        printf("%s%s\n", [[self newLineHeader] UTF8String], [print UTF8String]);
    }
}

-(void)logCallingMethod
{
    if ([self shouldPrintForType:kPrintDeveloper])
    {
        printf("%s\n", [[NSString stringWithFormat:@"%@.%@|%lld| ", self.currentLoggingClass, self.currentLoggingMethod, self.currentLineNumber] UTF8String]);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - basic elements
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logReturn
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("\n");
    }
}

-(void)logLine
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s---------------------------------------------\n", [[self newLineHeader] UTF8String]);
    }
}

-(void)logDenseLine
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s*********************************************\n", [[self newLineHeader] UTF8String]);
    }
}

-(void)logLongLine
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s-------------------------------------------------------------------------------------------------------------------\n", [[self newLineHeader] UTF8String]);
    }
}

-(void)logLongDenseLine
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s*******************************************************************************************************************\n", [[self newLineHeader] UTF8String]);
    }
}

-(void)logHeader: (NSString *)string, ...
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        va_list args;
        va_start(args, string);
        NSString *print=[[NSString alloc] initWithFormat:string arguments:args];
        va_end(args);
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        printf("%s*********************************************\n%s%s\n%s*********************************************\n", [newLineHeader UTF8String], [newLineSpacing UTF8String], [print UTF8String], [newLineSpacing UTF8String]);
    }
}

-(void)logSubHeader: (NSString *)string, ...
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        va_list args;
        va_start(args, string);
        NSString *print=[[NSString alloc] initWithFormat:string arguments:args];
        va_end(args);
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        printf("%s---------------------------------------------\n%s%s\n%s---------------------------------------------\n", [newLineHeader UTF8String], [newLineSpacing UTF8String], [print UTF8String], [newLineSpacing UTF8String]);
    }
}

-(void)logImportant: (NSString *)string, ...
{
    if ([self shouldPrintForType:kPrintDeveloper])
    {
        va_list args;
        va_start(args, string);
        NSString *print=[[NSString alloc] initWithFormat:string arguments:args];
        va_end(args);
        printf("%s>>> %s <<<\n", [[self newLineHeader] UTF8String], [print UTF8String]);
    }
}

-(void)logVeryImportant: (NSString *)string, ...
{
    if ([self shouldPrintForType:kPrintCritical])
    {
        va_list args;
        va_start(args, string);
        NSString *print=[[NSString alloc] initWithFormat:string arguments:args];
        va_end(args);
        printf("%s*** %s ***\n", [[self newLineHeader] UTF8String], [print UTF8String]);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PRINTING VARIABLES
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logChar: (char)character
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %c (char)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], character);
    }
}

-(void)logShortInt: (short int)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %hi (short int)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logUnsignedShortInt: (unsigned short int)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %hu (unsigned short int)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logInt: (int)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %i (int)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logUnsignedInt: (unsigned int)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %u (unsigned int)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logLongInt: (long int)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %li (long int)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logUnsignedLongInt: (unsigned long int)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %lu (unsigned long int)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logLongLongInt: (long long int)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %lli (long long int)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logUnsignedLongLongInt: (unsigned long long int)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %llu (unsigned long long int)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logFloat: (float)number
 roundingResult: (BOOL)rounding
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (rounding)
        {
            printf("%s%s: %.3f (float)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
        }
        else
        {
            printf("%s%s: %f (float)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
        }
    }
}

-(void)logDouble: (double)number
  roundingResult: (BOOL)rounding
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (rounding)
        {
            printf("%s%s: %.3lf (double)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
        }
        else
        {
            printf("%s%s: %lf (double)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
        }
    }
}

-(void)logLongDouble: (long double)number
      roundingResult: (BOOL)rounding
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (rounding)
        {
            printf("%s%s: %.3Lf (long double)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
        }
        else
        {
            printf("%s%s: %Lf (long double)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
        }
    }
}

-(void)logExponentialFloat: (float)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %e (float)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logExponentialDouble: (double)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %le (double)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logExponentialLongDouble: (long double)number
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: %Le (long double)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], number);
    }
}

-(void)logBoolean: (BOOL)boolean
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (boolean)
        {
            printf("%s%s: YES (boolean)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String]);
        }
        else
        {
            printf("%s%s: NO (boolean)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String]);
        }
    }
}

-(void)logString: (NSString *)string, ...
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (!string)
        {
            printf("%s%s: (null) (NSString)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String]);
            return;
        }
        
        va_list args;
        va_start(args, string);
        NSString *print=[[NSString alloc] initWithFormat:string arguments:args];
        va_end(args);
        
        printf("%s%s: \"%s\" (NSString)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [print UTF8String]);
    }
}

-(void)logCString: (char *)string
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (!string)
        {
            printf("%s%s: (null) (CString)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String]);
            return;
        }
        
        printf("%s%s: \"%s\" (NSString)\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], string);
        
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - structs
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logRect: (CGRect)rect
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: rect{ x:%.0f | y:%.0f | w:%.0f | h:%.0f }\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    }
}

-(void)logFrame: (CGRect)frame
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: frame{ x:%.0f | y:%.0f | w:%.0f | h:%.0f }\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
}

-(void)logPoint: (CGPoint)point
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: point{ x:%.0f | y:%.0f }\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], point.x, point.y);
    }
}

-(void)logSize: (CGSize)size
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: size{ w:%.0f | h:%.0f }\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], size.width, size.height);
    }
}

-(void)logRange: (NSRange)range
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s: range{ from:%li | for:%li }\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], (long int)range.location, (long int)range.length);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - objects
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logObjectPointer:(NSObject *)object
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s -> %p\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], object);
    }
}

-(void)logObjectInfo: (NSObject *)object
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (!object)
        {
            NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@%@:: (null)\n", [self newLineHeader], self.currentLoggingVariable];
            printf("%s", [outputString UTF8String]);
            return;
        }
        
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        NSString *spaceString = @"    ";
        NSString *className = [self getValidClassName:[object class]];
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@%@::\n", newLineHeader, self.currentLoggingVariable];
        [outputString appendFormat:@"%@%@class:       %@\n", newLineSpacing, spaceString, className];
        [outputString appendFormat:@"%@%@superclass:  %@\n", newLineSpacing, spaceString, [self getValidSuperclassNameOfClass:NSClassFromString(className)]];
        [outputString appendString:[self objectDescription:object withSpacing:[NSString stringWithFormat:@"%@%@", newLineSpacing, spaceString]]];
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logObjectInheritance: (NSObject *)object
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s (%s) inherits from:\n%s", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [[self getValidClassName:[object class]] UTF8String], [[self recursiveObjectClasses:[object class] withStartingIndentSpace:1] UTF8String]);
    }
}

-(void)logObjectParent: (NSObject *)object
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        NSString *currentClassName = [self getValidClassName:[object class]];
        printf("%s%s (%s) superclass: %s\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [currentClassName UTF8String], [[self getValidSuperclassNameOfClass:NSClassFromString(currentClassName)] UTF8String]);
    }
}

-(NSString *)objectDescription: (NSObject *)object withSpacing:(NSString *)spacing
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@description: ", spacing];
        if ([object respondsToSelector:@selector(logDescriptionWithSpacing:)])
        {
            [outputString appendString:[(id)object logDescriptionWithSpacing:spacing]];
        }
        else
        {
            [outputString appendFormat:@"%@\n", [object description]];
        }
        return outputString;
    }
    return @"";
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - core foundation objects
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logCFObjectInfo: (CFTypeRef)object
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        printf("%s---------------------------------------------\n%s%s's CFObject standard description::\n%s---------------------------------------------\n", [newLineHeader UTF8String], [newLineSpacing UTF8String], [self.currentLoggingVariable UTF8String], [newLineSpacing UTF8String]);
        CFShow(object);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - core data
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logManagedObjectId: (NSManagedObject *)object
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        printf("%s%s -> %s\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [[[object.objectID URIRepresentation] absoluteString] UTF8String]);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - object comparizon
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logIsObject: (NSObject *)object1
          withName:(char *)object1Name
     equalToObject: (NSObject *)object2
          withName:(char *)object2Name
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if ([object1  isEqual: object2])
        {
            printf("%s'%s' is equal to '%s'\n", [[self newLineHeader] UTF8String], object1Name, object2Name);
        }
        else
        {
            printf("%s'%s' is not equal to '%s'\n", [[self newLineHeader] UTF8String], object1Name, object2Name);
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - views
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logViewChild: (UIView *)view
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if ([[view subviews] count] == 0)
        {
            printf("%s%s (%s) has no subviews\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [[self getValidClassName:[view class]] UTF8String]);
            return;
        }
        
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@%@ (%@) subviews::\n", [self newLineHeader], self.currentLoggingVariable, [self getValidClassName:[view class]]];
        NSString *newLineSpacing = [self newLineHeader];
        NSString *spaceString = @"    ";
        unsigned int count = 0;
        for (UIView *subview in [view subviews])
        {
            CGRect frame = subview.frame;
            [outputString appendFormat:@"%@%@%u - %@ ( %.0f, %.0f, %.0f, %.0f )\n", newLineSpacing, spaceString, count, [self getValidClassName:[subview class]], frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
            count++;
        }
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logViewParent: (UIView *)view
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (![view superview])
        {
            printf("%s%s (%s) has no superview\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [[self getValidClassName:[view class]] UTF8String]);
            return;
        }
        CGRect frame = view.superview.frame;
        printf("%s%s (%s) superview:: %s ( %.0f, %.0f, %.0f, %.0f )\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [[self getValidClassName:[view class]] UTF8String], [[self getValidClassName:[view.superview class]] UTF8String], frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
}

-(void)logViewChildren: (UIView *)view
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if ([[view subviews] count] == 0)
        {
            printf("%s%s (%s) has no subviews\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [[self getValidClassName:[view class]] UTF8String]);
            return;
        }
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@%@ (%@) subviews hierarchy::\n", [self newLineHeader], self.currentLoggingVariable, [self getValidClassName:[view class]]];
        [outputString appendString:[self recursiveViewSubviews:view
                                       withStartingIndentSpace:1]];
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logViewParents: (UIView *)view
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        if (![view superview])
        {
            printf("%s%s (%s) has no superview\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [[self getValidClassName:[view class]] UTF8String]);
            return;
        }
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@%@ (%@) superview hierarchy::\n", [self newLineHeader], self.currentLoggingVariable, [self getValidClassName:[view class]]];
        [outputString appendString:[self recursiveViewSuperviews:view
                                         withStartingIndentSpace:1]];
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logViewFrame: (UIView *)view
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        CGRect frame = view.frame;
        printf("%s%s (%s):: frame{ x:%.0f | y:%.0f | w:%.0f | h:%.0f }\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [[self getValidClassName:[view class]] UTF8String], frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
}

-(void)logViewCenter: (UIView *)view
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        CGPoint point = view.center;
        printf("%s%s (%s):: center{ x:%.0f | y:%.0f }\n", [[self newLineHeader] UTF8String], [self.currentLoggingVariable UTF8String], [self.currentLoggingVariable UTF8String], point.x, point.y);
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - system info
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logSystemLimitsForTypes
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@-------------------------------------------------------------------------------------------------------------------\n%@system limits for types::\n%@-------------------------------------------------------------------------------------------------------------------\n", newLineHeader, newLineSpacing, newLineSpacing];
        [outputString appendFormat:@"%@    SHRT_MIN   (short int):              %d\n",newLineSpacing,SHRT_MIN];
        [outputString appendFormat:@"%@    SHRT_MAX   (short int):               %d\n", newLineSpacing,SHRT_MAX];
        [outputString appendFormat:@"%@    USHORT_MIN (unsigned short int):      0 [undefined, it's always zero]\n", newLineSpacing];
        [outputString appendFormat:@"%@    USHORT_MAX (unsigned short int):      %ud\n", newLineSpacing, USHRT_MAX];
        [outputString appendFormat:@"%@    INT_MIN    (int):                    %i\n", newLineSpacing, INT_MIN];
        [outputString appendFormat:@"%@    INT_MAX    (int):                     %i\n", newLineSpacing, INT_MAX];
        [outputString appendFormat:@"%@    UINT_MIN   (unsigned int):            0 [undefined, it's always zero]\n", newLineSpacing];
        [outputString appendFormat:@"%@    UINT_MAX   (unsigned int):            %ui\n", newLineSpacing, UINT_MAX];
        [outputString appendFormat:@"%@    LONG_MIN   (long int):               %li\n", newLineSpacing,  LONG_MIN];
        [outputString appendFormat:@"%@    LONG_MAX   (long int):                %li\n", newLineSpacing,  LONG_MAX];
        [outputString appendFormat:@"%@    ULONG_MIN  (unsigned long int):       0 [undefined, it's always zero]\n", newLineSpacing];
        [outputString appendFormat:@"%@    ULONG_MAX  (unsigned long int):       %lu\n", newLineSpacing,  ULONG_MAX];
        [outputString appendFormat:@"%@    LLONG_MIN  (long long int):          %lli\n", newLineSpacing, LLONG_MIN];
        [outputString appendFormat:@"%@    LLONG_MAX  (long long int):           %lli\n", newLineSpacing, LLONG_MAX];
        [outputString appendFormat:@"%@    ULLONG_MIN (unsigned long long int):  0 [undefined, it's always zero]\n", newLineSpacing];
        [outputString appendFormat:@"%@    ULLONG_MAX (unsigned long long int):  %llu\n", newLineSpacing, ULLONG_MAX];
        [outputString appendFormat:@"%@-------------------------------------------------------------------------------------------------------------------\n", newLineSpacing];
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logCurrentThreadInfo
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@---------------------------------------------\n%@current thread info::\n%@---------------------------------------------", newLineHeader, newLineSpacing, newLineSpacing];
        [outputString appendString:[[NSThread currentThread] logDescriptionWithSpacing:newLineSpacing]];
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logThreadStackInfo
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@---------------------------------------------\n%@current thread stack info::\n%@---------------------------------------------\n", newLineHeader, newLineSpacing, newLineSpacing];
        [outputString appendString:[[NSThread currentThread] logStackDescriptionWithSpacing:newLineSpacing]];
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logTime
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        NSString *currentTime = [dateFormatter stringFromDate:now];
        printf("%stime: %s\n", [[self newLineHeader] UTF8String], [currentTime UTF8String]);
    }
}

-(void)logAvailableFonts
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        NSString *newLineHeader = [self newLineHeader];
        NSString *newLineSpacing = [self newLineHeader];
        
        NSMutableString *outputString = [NSMutableString stringWithFormat:@"%@-------------------------------------------------------------------------------------------------------------------\n", newLineHeader];
        [outputString appendFormat:@"%@SYSTEM FONTS:\n", newLineSpacing];
        NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
        NSArray *fontNames = nil;
        NSInteger familyIndex, fontIndex;
        for (familyIndex=0; familyIndex<[familyNames count]; familyIndex++)
        {
            [outputString appendFormat:@"%@    Family name: %@\n", newLineSpacing, [familyNames objectAtIndex:familyIndex]];
            fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:familyIndex]]];
            for (fontIndex=0; fontIndex<[fontNames count]; fontIndex++)
            {
                [outputString appendFormat:@"%@        -> %@\n", newLineSpacing, [fontNames objectAtIndex:fontIndex]];
            }
        }
        [outputString appendFormat:@"%@-------------------------------------------------------------------------------------------------------------------\n", newLineSpacing];
        printf("%s", [outputString UTF8String]);
    }
}

-(void)logDeviceOrientation: (UIDeviceOrientation)orientation
{
    if ([self shouldPrintForType:kPrintWorkflow])
    {
        switch (orientation) {
            case UIDeviceOrientationLandscapeRight:
                printf("%sdevice orientation: landscape right\n", [[self newLineHeader] UTF8String]);
                break;
            case UIDeviceOrientationLandscapeLeft:
                printf("%sdevice orientation: landscape left\n", [[self newLineHeader] UTF8String]);
                break;
            case UIDeviceOrientationPortrait:
                printf("%sdevice orientation: portrait\n", [[self newLineHeader] UTF8String]);
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                printf("%sdevice orientation: portrait upside down\n", [[self newLineHeader] UTF8String]);
                break;
            case UIDeviceOrientationFaceDown:
                printf("%sdevice orientation: face down\n", [[self newLineHeader] UTF8String]);
                break;
            case UIDeviceOrientationFaceUp:
                printf("%sdevice orientation: face up\n", [[self newLineHeader] UTF8String]);
                break;
            case UIDeviceOrientationUnknown:
                printf("%sdevice orientation: unknown\n", [[self newLineHeader] UTF8String]);
                break;
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - WTF?!
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)logIDDQD
{
    if (kCMLogger_ShouldLog)
    {
        printf("*******************************************************************************************************************\n*******************************************************************************************************************\nYou are now coding in god mode.\n*******************************************************************************************************************\n*******************************************************************************************************************\n");
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - singleton methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+(CMLogger*)logger
{
    static CMLogger *defaultLogger = nil;
    if (defaultLogger == nil)
    {
        defaultLogger = [[super allocWithZone:NULL] init];
        
        // set initial variable data
        defaultLogger.currentCallingMethodLength = -1;
        [defaultLogger logIDDQD];
    }
    
    return defaultLogger;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self logger];
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
