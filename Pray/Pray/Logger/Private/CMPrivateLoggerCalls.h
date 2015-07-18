//
//  CMPrivateLoggerCalls.h
//  CMLogger
//
//  Created by Jason LAPIERRE on 15/10/2012.
//  Copyright (c) 2012 Jason LAPIERRE a.k.a. The One Man Corporation. All rights reserved.
//

#ifndef CMLogger_CMPrivateLoggerCalls_h
#define CMLogger_CMPrivateLoggerCalls_h

#import "CMLogger.h"

// printing type definitions are declared here:
typedef enum
{
    kPrintWorkflow  = 0,
    kPrintDeveloper = 1,
    kPrintCritical  = 2
    
} kPrintType;

/* NOTE:: all variables declared in this #ifdef should also be declared as blanks in the accompaining #else */
#ifdef DEBUG
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private debug logger defines
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define _loggerInstance                 [CMLogger logger]
#define _loggerVariableName(varName)    #varName == "((void*)0)" ? "(null)" : #varName
#define _loggerStart                    [_loggerInstance willStartLoggerSessionWithMethod:NSStringFromSelector(_cmd) inLineNumber:__LINE__ fromClass:NSStringFromClass([self class])]
#define _loggerStartVar(variable)       [_loggerInstance willStartLoggerSessionWithMethod:NSStringFromSelector(_cmd) inLineNumber:__LINE__ usingVariable:_loggerVariableName(variable) fromClass:NSStringFromClass([self class])]
#define _loggerEnd                      [_loggerInstance didEndLoggingSession]

#else
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private release logger defines
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define _loggerInstance                 
#define _loggerVariableName(variable)   
#define _loggerStart                    
#define _loggerEnd

#endif
#endif
