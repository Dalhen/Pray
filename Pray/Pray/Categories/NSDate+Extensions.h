//
//  NSDate+TimeTracking.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "JXTimeDefinitions.h"

/*-----------------------------------------------------------------------------------------------------*/

@interface NSDate (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *) dateWithYear:(NSInteger)year
                    month:(NSInteger)month
                      day:(NSInteger)day;
+ (NSDate *) dateFormUtcDateString:(NSString *)utcString;
+ (NSDate *) dateFromUTCServer:(NSString *)utcString;
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithYearsFromNow:(NSInteger)years;
+ (NSDate *) dateWithYearsBeforeNow:(NSInteger)years;
+ (NSDate *) dateWithMonthsFromNow:(NSInteger)months;
+ (NSDate *) dateWithMonthsBeforeNow:(NSInteger)months;
+ (NSDate *) dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *) dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *) dateWithHoursFromNow:(NSInteger)dHours;
+ (NSDate *) dateWithHoursBeforeNow:(NSInteger)dHours;
+ (NSDate *) dateWithMinutesFromNow:(NSInteger)dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow:(NSInteger)dMinutes;
+ (NSDate *) randomDate;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - timespan
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSInteger)minutesBetweenDate:(NSDate*)fromDateTime
                        andDate:(NSDate*)toDateTime;
+ (NSInteger)hoursBetweenDate:(NSDate*)fromDateTime
                      andDate:(NSDate*)toDateTime;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime
                     andDate:(NSDate*)toDateTime;
+ (NSInteger)weeksBetweenDate:(NSDate*)fromDateTime
                      andDate:(NSDate*)toDateTime;
+ (NSInteger)monthsBetweenDate:(NSDate*)fromDateTime
                       andDate:(NSDate*)toDateTime;
+ (NSInteger)yearsBetweenDate:(NSDate*)fromDateTime
                      andDate:(NSDate*)toDateTime;
+ (NSString *)getAgeFromBirthdate:(NSDate *)birthdate;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - data
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *) nameOfMonth:(int)monthIndex;
+ (NSString *) nameOfDay:(int)dayIndex;
+ (NSString *) stringForDate:(NSDate *)date andFormat:(NSString *)dateFormat;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - comparison
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isThisMonth;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isSameDayAsDate:(NSDate *)aDate; 
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isDateOlderThanMinutes:(NSInteger)minutes;
- (BOOL) isDateOlderThanHours:(NSInteger)hours;
- (BOOL) isDateOlderThanDays:(NSInteger)days;
- (BOOL) isDateOlderThanWeeks:(NSInteger)weeks;
- (BOOL) isInFuture;
- (BOOL) isInPast;
- (BOOL) isWorkday;
- (BOOL) isWeekend;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - string representation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *) shortDateString;
- (NSString *) shortTimedDateString;
- (NSString *) utcDateString;
- (NSString *) shortDayString;
- (NSString *) summaryString;
- (NSString *) localisedDateAndTimeLongString;
- (NSString *) localisedDateAndTimeString;
- (NSString *) localisedDateMediumString;
- (NSString *) localisedDateShortString;
- (NSString *) timeString;
- (NSString *) dateStringWithFormat:(NSString *)format;
 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - date generation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *) dateByAddingMinutes:(NSInteger)minutes
                           hours:(NSInteger)hours
                            days:(NSInteger)days
                          months:(NSInteger)months
                           years:(NSInteger)years;
- (NSDate *) dateByAddingDays:(NSInteger)days
                       months:(NSInteger)months
                        years:(NSInteger)years;
- (NSDate *) dateByAddingMonths:(NSInteger)months;
- (NSDate *) dateBySubtractingMonths:(NSInteger)months;
- (NSDate *) dateByAddingYears:(NSInteger)years;
- (NSDate *) dateBySubtractingYears:(NSInteger)months;
- (NSDate *) dateByAddingDays:(NSInteger)dDays;
- (NSDate *) dateBySubtractingDays:(NSInteger)dDays;
- (NSDate *) dateByAddingHours:(NSInteger)dHours;
- (NSDate *) dateBySubtractingHours:(NSInteger)dHours;
- (NSDate *) dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate *) dateBySubtractingMinutes:(NSInteger)dMinutes;
- (NSDate *) dateAtStartOfDay;
- (NSDate *) monthStartDate;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - date data
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger) minutesSinceMidnight;
- (NSUInteger) numberOfDaysInMonth;
- (NSUInteger) weekday;
- (NSUInteger) nearestHour;
- (NSUInteger) hour;
- (NSUInteger) minute;
- (NSUInteger) seconds;
- (NSUInteger) day;
- (NSUInteger) month;
- (NSUInteger) week;
- (NSUInteger) nthWeekday; // e.g. 2nd Tuesday of the month == 2
- (NSUInteger) year;
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger) weeksAfterDate: (NSDate *) aDate;
- (NSInteger) weeksBeforeDate: (NSDate *) aDate;
- (NSInteger) distanceInDaysToDate:(NSDate *)anotherDate;

+ (NSDate *) dateWithString:(NSString *) dateStr format:(NSString *) formatStr;

@end
