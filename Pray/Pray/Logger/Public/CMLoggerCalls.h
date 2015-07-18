//
//  CMLoggerCalls.h
//  CMLogger
//
//  Created by Jason LAPIERRE on 15/10/2012.
//  Copyright (c) 2012 Jason LAPIERRE a.k.a. The One Man Corporation. All rights reserved.
//

#ifndef CMLogger_CMLoggerCalls_h
#define CMLogger_CMLoggerCalls_h

#import "CMPrivateLoggerCalls.h"

// NOTE:: all variables declared in this #ifdef should also be declared as blanks in the accompaining #else
#ifdef DEBUG
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - debug logger defines
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//system info calls
#define printSystemLimits                       _loggerStart; [_loggerInstance logSystemLimitsForTypes]; _loggerEnd
#define printThreadInfo                         _loggerStart; [_loggerInstance logCurrentThreadInfo]; _loggerEnd
#define printThreadStackInfo                    _loggerStart; [_loggerInstance logThreadStackInfo]; _loggerEnd
#define printTime                               _loggerStart; [_loggerInstance logTime]; _loggerEnd
#define printAvailableFonts                     _loggerStart; [_loggerInstance logAvailableFonts]; _loggerEnd
#define printOrientation(UIDeviceOrientation)   _loggerStart; [_loggerInstance logDeviceOrientation:UIDeviceOrientation]; _loggerEnd

//basic
#define printReturn                         _loggerStart; [_loggerInstance logReturn]; _loggerEnd
#define printLine                           _loggerStart; [_loggerInstance logLine]; _loggerEnd
#define printDenseLine                      _loggerStart; [_loggerInstance logDenseLine]; _loggerEnd
#define printLongLine                       _loggerStart; [_loggerInstance logLongLine]; _loggerEnd
#define printLongDenseLine                  _loggerStart; [_loggerInstance logLongDenseLine]; _loggerEnd
#define printHeader(NSString, ...)          _loggerStart; [_loggerInstance logHeader:NSString, ##__VA_ARGS__]; _loggerEnd
#define printSubheader(NSString, ...)       _loggerStart; [_loggerInstance logSubHeader:NSString, ##__VA_ARGS__]; _loggerEnd
#define printImportant(NSString, ...)       _loggerStart; [_loggerInstance logImportant:NSString, ##__VA_ARGS__]; _loggerEnd
#define printVeryImportant(NSString, ...)   _loggerStart; [_loggerInstance logVeryImportant:NSString, ##__VA_ARGS__]; _loggerEnd

//developer
#define printError(NSError)                 _loggerStartVar(NSError); [_loggerInstance logError:NSError]; _loggerEnd;
#define printErrorAndAbort(NSError)         _loggerStartVar(NSError); [_loggerInstance logError:NSError]; _loggerEnd; abort()
#define printFailPoint                      _loggerStart; [_loggerInstance logFailPt]; _loggerEnd
#define printFailPointAndAbort              _loggerStart; [_loggerInstance logFailPt]; _loggerEnd; abort()
#define printFail(NSString, ...)            _loggerStart; [_loggerInstance logFail:NSString, ##__VA_ARGS__]; _loggerEnd
#define printFailAndAbort(NSString, ...)    _loggerStart; [_loggerInstance logFail:NSString, ##__VA_ARGS__]; _loggerEnd; abort()
#define printNote(NSString, ...)            _loggerStart; [_loggerInstance logNote:NSString, ##__VA_ARGS__]; _loggerEnd
#define printTodoPoint                      _loggerStart; [_loggerInstance logTodoPt]; _loggerEnd
#define printTodo(NSString, ...)            _loggerStart; [_loggerInstance logTodo:NSString, ##__VA_ARGS__]; _loggerEnd
#define print(NSString, ...)                _loggerStart; [_loggerInstance log:NSString, ##__VA_ARGS__]; _loggerEnd
#define printCallingMethod                  _loggerStart; [_loggerInstance logCallingMethod]; _loggerEnd

//variables
#define printChar(char)                                 _loggerStartVar(char); [_loggerInstance logChar:char]; _loggerEnd
#define printShortInt(shortInt)                         _loggerStartVar(shortInt); [_loggerInstance logShortInt:shortInt]; _loggerEnd
#define printUnsignedShortInt(unsignedShortInt)         _loggerStartVar(unsignedShortInt); [_loggerInstance logUnsignedShortInt:unsignedShortInt]; _loggerEnd
#define printInt(int)                                   _loggerStartVar(int); [_loggerInstance logInt:int]; _loggerEnd
#define printUnsignedInt(unsignedInt)                   _loggerStartVar(unsignedInt); [_loggerInstance logUnsignedInt:unsignedInt]; _loggerEnd
#define printLongInt(longInt)                           _loggerStartVar(longInt); [_loggerInstance logLongInt:longInt]; _loggerEnd
#define printUnsignedLongInt(unsignedLongInt)           _loggerStartVar(unsignedLongInt); [_loggerInstance logUnsignedLongInt:unsignedLongInt]; _loggerEnd
#define printLongLongInt(longLongInt)                   _loggerStartVar(longLongInt); [_loggerInstance logLongLongInt:longLongInt]; _loggerEnd
#define printUnsignedLongLongInt(unsignedLongLongInt)   _loggerStartVar(unsignedLongLongInt); [_loggerInstance logUnsignedLongLongInt:unsignedLongLongInt]; _loggerEnd
#define printFloat(float)                               _loggerStartVar(float); [_loggerInstance logFloat:float roundingResult:NO]; _loggerEnd
#define printFloatRounded(float)                        _loggerStartVar(float); [_loggerInstance logFloat:float roundingResult:YES]; _loggerEnd
#define printFloatExponential(float)                    _loggerStartVar(float); [_loggerInstance logExponentialFloat:float]; _loggerEnd
#define printDouble(double)                             _loggerStartVar(double); [_loggerInstance logDouble:double roundingResult:NO]; _loggerEnd
#define printDoubleRounded(double)                      _loggerStartVar(double); [_loggerInstance logDouble:double roundingResult:YES]; _loggerEnd
#define printDoubleExponential(double)                  _loggerStartVar(double); [_loggerInstance logExponentialDouble:double]; _loggerEnd
#define printLongDouble(longDouble)                     _loggerStartVar(longDouble); [_loggerInstance logLongDouble:longDouble roundingResult:NO]; _loggerEnd
#define printLongDoubleRounded(longDouble)              _loggerStartVar(longDouble); [_loggerInstance logLongDouble:longDouble roundingResult:YES]; _loggerEnd
#define printLongDoubleExponential(longDouble)          _loggerStartVar(longDouble); [_loggerInstance logExponentialLongDouble:longDouble]; _loggerEnd
#define printBoolean(boolean)                           _loggerStartVar(boolean); [_loggerInstance logBoolean:boolean]; _loggerEnd
#define printString(NSString, ...)                      _loggerStartVar(NSString); [_loggerInstance logString:NSString, ##__VA_ARGS__]; _loggerEnd
#define printCString(CString)                           _loggerStartVar(CString); [_loggerInstance logCString:CString]; _loggerEnd

//structures
#define printRect(CGRect)       _loggerStartVar(CGRect); [_loggerInstance logRect:CGRect]; _loggerEnd
#define printFrame(CGRect)      _loggerStartVar(CGRect); [_loggerInstance logFrame:CGRect]; _loggerEnd
#define printPoint(CGPoint)     _loggerStartVar(CGPoint); [_loggerInstance logPoint:CGPoint]; _loggerEnd
#define printSize(CGSize)       _loggerStartVar(CGSize); [_loggerInstance logSize:CGSize]; _loggerEnd
#define printRange(NSRange)     _loggerStartVar(NSRange); [_loggerInstance logRange:NSRange]; _loggerEnd

//objects
#define printObjectPointer(NSObject)        _loggerStartVar(NSObject); [_loggerInstance logObjectPointer:NSObject]; _loggerEnd
#define printObject(NSObject)               _loggerStartVar(NSObject); [_loggerInstance logObjectInfo:NSObject]; _loggerEnd
#define printObjectInheritance(NSObject)    _loggerStartVar(NSObject); [_loggerInstance logObjectInheritance:NSObject]; _loggerEnd
#define printObjectParent(NSObject)         _loggerStartVar(NSObject); [_loggerInstance logObjectParent:NSObject]; _loggerEnd
#define printCFObject(CFObject)             _loggerStartVar(CFObject); [_loggerInstance logCFObjectInfo:CFObject]; _loggerEnd

//core data
#define printManagedObjectId(NSManagedObject)   _loggerStartVar(NSManagedObject); [_loggerInstance logManagedObjectId:NSManagedObject]; _loggerEnd

//equality
#define printObjectsAreEqual(NSObject1, NSObject2) _loggerStart; [_loggerInstance logIsObject:NSObject1 withName:_loggerVariableName(NSObject1) equalToObject:NSObject2 withName:_loggerVariableName(NSObject2)]; _loggerEnd

//views
#define printViewChildren(UIView)           _loggerStartVar(UIView); [_loggerInstance logViewChild:UIView]; _loggerEnd
#define printViewParent(UIView)             _loggerStartVar(UIView); [_loggerInstance logViewParent:UIView]; _loggerEnd
#define printViewChildrenExtended(UIView)   _loggerStartVar(UIView); [_loggerInstance logViewChildren:UIView]; _loggerEnd
#define printViewParentsExtended(UIView)    _loggerStartVar(UIView); [_loggerInstance logViewParents:UIView]; _loggerEnd
#define printViewPosition(UIView)           _loggerStartVar(UIView); [_loggerInstance logViewFrame:UIView]; _loggerEnd
#define printViewCenter(UIView)             _loggerStartVar(UIView); [_loggerInstance logViewCenter:UIView]; _loggerEnd

#else
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - release logger defines
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//system info calls
#define printSystemLimits
#define printThreadInfo
#define printThreadStackInfo
#define printTime
#define printAvailableFonts
#define printOrientation(UIDeviceOrientation)

//basic
#define printReturn
#define printLine
#define printDenseLine
#define printLongLine
#define printLongDenseLine
#define printHeader(NSString, ...)
#define printSubheader(NSString, ...)
#define printImportant(NSString, ...)
#define printVeryImportant(NSString, ...)

//developer
#define printError(NSError)
#define printErrorAndAbort(NSError)
#define printFailPoint
#define printFailPointAndAbort
#define printFail(NSString, ...)
#define printFailAndAbort(NSString, ...)
#define printNote(NSString, ...)
#define printTodoPoint
#define printTodo(NSString, ...)
#define print(NSString, ...)
#define printCallingMethod

//variables
#define printChar(char)
#define printShortInt(shortInt)
#define printUnsignedShortInt(unsignedShortInt)
#define printInt(int)
#define printUnsignedInt(unsignedInt)
#define printLongInt(longInt)
#define printUnsignedLongInt(unsignedLongInt)
#define printLongLongInt(longLongInt)
#define printUnsignedLongLongInt(unsignedLongLongInt)
#define printFloat(float)
#define printFloatRounded(float)
#define printFloatExponential(float)
#define printDouble(double)
#define printDoubleRounded(double)
#define printDoubleExponential(double)
#define printLongDouble(longDouble)
#define printLongDoubleRounded(longDouble)
#define printLongDoubleExponential(longDouble)
#define printBoolean(boolean)
#define printString(NSString, ...)
#define printCString(CString)

//structures
#define printRect(CGRect)
#define printFrame(CGRect)
#define printPoint(CGPoint)
#define printSize(CGSize)
#define printRange(NSRange)

//objects
#define printObjectPointer(NSObject)
#define printObject(NSObject)
#define printObjectInheritance(NSObject)
#define printObjectParent(NSObject)
#define printCFObject(CFObject)

//core data
#define printManagedObjectId(NSManagedObject)

//equality
#define printObjectsAreEqual(NSObject1, NSObject2)

//views
#define printViewChildren(UIView)
#define printViewParent(UIView)
#define printViewChildrenExtended(UIView)
#define printViewParentsExtended(UIView)
#define printViewPosition(UIView)
#define printViewCenter(UIView)

#endif
#endif
