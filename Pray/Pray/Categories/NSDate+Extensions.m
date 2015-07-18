//
//  NSDate+TimeTracking.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSDate+Extensions.h"

/*-----------------------------------------------------------------------------------------------------*/

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSDate (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateFormUtcDateString:(NSString *)utcString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return [formatter dateFromString:utcString];
}

+ (NSDate *)dateFromUTCServer:(NSString *)utcString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:utcString];
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithYearsFromNow:(NSInteger)years
{
    return [[NSDate date] dateByAddingYears:years];
}

+ (NSDate *) dateWithYearsBeforeNow:(NSInteger)years
{
    return [[NSDate date] dateBySubtractingYears:years];
}

+ (NSDate *) dateWithMonthsFromNow:(NSInteger)months
{
    return [[NSDate date] dateByAddingMonths:months];
}

+ (NSDate *) dateWithMonthsBeforeNow:(NSInteger)months
{
    return [[NSDate date] dateBySubtractingMonths:months];
}

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kNSDate_secondsInOneDay * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - kNSDate_secondsInOneDay * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kNSDate_secondsInOneHour * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - kNSDate_secondsInOneHour * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kNSDate_secondsInOneMinute * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - kNSDate_secondsInOneMinute * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *)randomDate {
    NSTimeInterval period = (NSTimeInterval)arc4random_uniform(500000) - 250000;
    return [NSDate dateWithTimeIntervalSinceNow:period];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - timespan
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSInteger)minutesBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&fromDate
                 interval:NULL
                  forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&toDate
                 interval:NULL
                  forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSMinuteCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return [difference minute];
}

+ (NSInteger)hoursBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&fromDate
                 interval:NULL
                  forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&toDate
                 interval:NULL
                  forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSHourCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return [difference hour];
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&fromDate
                 interval:NULL
                  forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&toDate
                 interval:NULL
                  forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return [difference day];
}

+ (NSInteger)weeksBetweenDate:(NSDate*)fromDateTime
                      andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSWeekCalendarUnit
                startDate:&fromDate
                 interval:NULL
                  forDate:fromDateTime];
    [calendar rangeOfUnit:NSWeekCalendarUnit
                startDate:&toDate
                 interval:NULL
                  forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSWeekCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return [difference week];
}

+ (NSInteger)monthsBetweenDate:(NSDate*)fromDateTime
                       andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSMonthCalendarUnit
                startDate:&fromDate
                 interval:NULL
                  forDate:fromDateTime];
    [calendar rangeOfUnit:NSMonthCalendarUnit
                startDate:&toDate
                 interval:NULL
                  forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSMonthCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return [difference month];
}

+ (NSInteger)yearsBetweenDate:(NSDate*)fromDateTime
                      andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSYearCalendarUnit
                startDate:&fromDate
                 interval:NULL
                  forDate:fromDateTime];
    [calendar rangeOfUnit:NSYearCalendarUnit
                startDate:&toDate
                 interval:NULL
                  forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSYearCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return [difference year];
}

+ (NSString *)getAgeFromBirthdate:(NSDate *)birthdate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit
                                           fromDate:birthdate
                                             toDate:[NSDate date]
                                            options:0];
    return [NSString stringWithFormat:@"%li", (long)[comps year]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - names
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *) nameOfMonth:(int)monthIndex;
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    return [[df monthSymbols] objectAtIndex:(monthIndex-1)];
}

+ (NSString *) nameOfDay:(int)dayIndex;
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    return [[df weekdaySymbols] objectAtIndex:(dayIndex-1)];
}

+ (NSString *)stringForDate:(NSDate *)date andFormat:(NSString *)dateFormat {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    return [df stringFromDate:date];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - comparison
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) &&
			(components1.day == components2.day));
}


- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL)isSameDayAsDate:(NSDate *)aDate
{
    NSDateComponents *components = [CURRENT_CALENDAR components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *compareDate = [CURRENT_CALENDAR dateFromComponents:components];
    components = [CURRENT_CALENDAR components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    NSDate *currentDate = [CURRENT_CALENDAR dateFromComponents:components];
    
    return [compareDate isEqualToDate:currentDate];
}

- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    if (components1.week != components2.week) return NO;
	
	return (abs([self timeIntervalSinceDate:aDate]) < kNSDate_secondsInOneWeek);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kNSDate_secondsInOneWeek;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - kNSDate_secondsInOneWeek;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL) isDateOlderThanMinutes:(NSInteger)minutes
{
    return (abs([self timeIntervalSinceNow]) > kNSDate_secondsInOneMinute*minutes);
}

- (BOOL) isDateOlderThanHours:(NSInteger)hours
{
    return (abs([self timeIntervalSinceNow]) > kNSDate_secondsInOneHour*hours);
}

- (BOOL) isDateOlderThanDays:(NSInteger)days
{
    return (abs([self timeIntervalSinceNow]) > kNSDate_secondsInOneDay*days);
}

- (BOOL) isDateOlderThanWeeks:(NSInteger)weeks
{
    return (abs([self timeIntervalSinceNow]) > kNSDate_secondsInOneWeek*weeks);
}

- (BOOL) isInFuture
{
    return [self isLaterThanDate:[NSDate date]];
}

- (BOOL) isInPast
{
    return [self isEarlierThanDate:[NSDate date]];
}

- (BOOL) isWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isWorkday
{
    return ![self isWeekend];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - string representation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)shortDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)shortTimedDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss dd/MM/yyyy"];
    return [dateFormatter stringFromDate:self];

}

-(NSString *)utcDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

- (NSString *)summaryString
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	
	NSDate *suppliedDate = [calendar dateFromComponents:comps];
	
	for (int i = -1; i < 7; i++) {
		comps = [calendar components:unitFlags fromDate:[NSDate date]];
		[comps setHour:0];
		[comps setMinute:0];
		[comps setSecond:0];
		[comps setDay:[comps day] - i];
		
		NSDate *referenceDate = [calendar dateFromComponents:comps];
		
		NSInteger weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
        
		if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {
			NSString *summary = [NSString stringWithFormat:@"Tomorrow"];
			return summary;
		} else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0)	{
			NSString *summary = [NSString stringWithFormat:@"Today"];
			return summary;
		} else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
			NSString *summary = [NSString stringWithFormat:@"Yesterday"];
			return summary;
		} else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
			NSString *day = [[formatter weekdaySymbols] objectAtIndex:weekday];
			NSString *summary = [NSString stringWithFormat:@"%@, %@.", day, [formatter stringFromDate:self]];
			return summary;
		}
	}
	
	[formatter setDateFormat:@"d MMM yyyy, HH:mm"];
	NSString *summary = [NSString stringWithFormat:@"%@.", [formatter stringFromDate:self]];
	
	return summary;
}

- (NSString *)shortDayString
{
    return [self dateStringWithFormat :@"EEE"];
}

- (NSString *)localisedDateAndTimeLongString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *)localisedDateAndTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *)localisedDateMediumString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *)localisedDateShortString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateFormat = [formatter.dateFormat copy];
    
    if([[[dateFormat substringToIndex:1] lowercaseString]isEqualToString:@"d"]) {
        formatter.dateFormat = @"dd-MM-YY";
    } else if([[[dateFormat substringToIndex:1] lowercaseString]isEqualToString:@"m"]) {
        formatter.dateFormat = @"MM-dd-YY";
    }else if([[[dateFormat substringToIndex:1] lowercaseString]isEqualToString:@"y"]) {
        formatter.dateFormat = @"YY-MM-dd";
    }
    
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *) timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *) dateStringWithFormat:(NSString *) format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
	return [formatter stringFromDate:self];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - date generation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *) dateByAddingMinutes:(NSInteger)minutes
                           hours:(NSInteger)hours
                            days:(NSInteger)days
                          months:(NSInteger)months
                           years:(NSInteger)years
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.day = days;
	dateComponents.month = months;
	dateComponents.year = years;
	dateComponents.minute = minutes;
    dateComponents.hour = hours;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

- (NSDate *) dateByAddingDays:(NSInteger)days
                       months:(NSInteger)months
                        years:(NSInteger)years
{
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.day = days;
	dateComponents.month = months;
	dateComponents.year = years;
	
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

- (NSDate *) dateByAddingMonths:(NSInteger) months
{
    return [self dateByAddingDays:0 months:months years:0];
}

- (NSDate *) dateBySubtractingMonths:(NSInteger)months
{
    return [self dateByAddingDays:0 months:-months years:0];
}

- (NSDate *) dateByAddingYears:(NSInteger) years
{
    return [self dateByAddingDays:0 months:0 years:years];
}

- (NSDate *) dateBySubtractingYears:(NSInteger) years
{
    return [self dateByAddingDays:0 months:0 years:-years];
}

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + kNSDate_secondsInOneDay * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + kNSDate_secondsInOneHour * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + kNSDate_secondsInOneMinute * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) monthStartDate
{
    NSDate *monthStartDate = nil;
	[[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit
                                    startDate:&monthStartDate
                                     interval:NULL
                                      forDate:self];
	return monthStartDate;
}

- (NSDate *) dateAtStartOfDay
{
    NSDate *midnightDate = nil;
	[[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                    startDate:&midnightDate
                                     interval:NULL
                                      forDate:self];
	return midnightDate;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - date data
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger)minutesSinceMidnight {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self];
    NSUInteger minutesSinceMidnight = ([components hour] * 60) + [components minute];
    
    return minutesSinceMidnight;
}

- (NSUInteger) numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:self].length;
}

- (NSUInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kNSDate_secondsInOneMinute * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSUInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSUInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSUInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSUInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSUInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSUInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.week;
}

- (NSUInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekday;
}

- (NSUInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}

- (NSUInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.year;
}

- (NSInteger) minutesAfterDate: (NSDate *) aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / kNSDate_secondsInOneMinute);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / kNSDate_secondsInOneMinute);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / kNSDate_secondsInOneHour);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / kNSDate_secondsInOneHour);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / kNSDate_secondsInOneDay);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / kNSDate_secondsInOneDay);
}

- (NSInteger) weeksAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / kNSDate_secondsInOneWeek);
}

- (NSInteger) weeksBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / kNSDate_secondsInOneWeek);
}

- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    return [NSDate daysBetweenDate:self
                           andDate:anotherDate];
}




+ (NSDate *) dateWithString:(NSString *) dateStr format:(NSString *) formatStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    return [dateFormatter dateFromString:dateStr];
}

@end
