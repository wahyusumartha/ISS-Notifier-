//
//  Schedule.m
//  ISS-Spot
//
//  Created by Wahyu Sumartha  on 4/20/13.
//  Copyright (c) 2013 Wahyu Sumartha . All rights reserved.
//

#import "Schedule.h"

@implementation Schedule

@synthesize duration = _duration;
@synthesize riseTime = _riseTime;
@synthesize durationRawDataInSeconds = _durationRawDataInSeconds;
@synthesize riseTimeInTimeStamp = _riseTimeInTimeStamp;
@synthesize fireDate = _fireDate;

@synthesize durationInHour = _durationInHour, durationInMinutes = _durationInMinutes, durationInSecond = _durationInSecond;

@synthesize dateOfRiseTime = _dateOfRiseTime, monthOfRiseTime = _monthOfRiseTime, yearOfRiseTime = _yearOfRiseTime, hourOfRiseTime = _hourOfRiseTime, minutesOfRiseTime = _minutesOfRiseTime, secondOfRiseTime = _secondOfRiseTime;


- (NSString *)duration
{
    int hours = _durationRawDataInSeconds / 3600;
    int remainder = _durationRawDataInSeconds % 3600;
    int minutes = remainder / 60;
    int seconds = remainder % 60;
    
    _durationInHour = hours;
    _durationInMinutes = minutes;
    _durationInSecond = seconds;
    
    return [NSString stringWithFormat:@"%d:%d:%d", hours, minutes, seconds];
}

- (NSString *)riseTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_riseTimeInTimeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];

    return [formatter stringFromDate:date];
}

- (NSString *)dateOfRiseTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_riseTimeInTimeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    
    return [formatter stringFromDate:date];
}

- (NSString *)monthOfRiseTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_riseTimeInTimeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    
    return [formatter stringFromDate:date];
}

- (NSString *)yearOfRiseTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_riseTimeInTimeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    return [formatter stringFromDate:date];
}

- (NSInteger)hourOfRiseTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_riseTimeInTimeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    
    return [[formatter stringFromDate:date] integerValue];
}

- (NSInteger)minutesOfRiseTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_riseTimeInTimeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    
    return [[formatter stringFromDate:date] integerValue];

}

- (NSInteger)secondOfRiseTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_riseTimeInTimeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss"];
    
    return [[formatter stringFromDate:date] integerValue];
}

- (NSDate *)fireDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_riseTimeInTimeStamp];
    
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    
    // Break the date up into components
	NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
												   fromDate:date];
	NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
												   fromDate:date];

    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
	// Notification will fire in one minute
    [dateComps setMinute:[timeComponents minute]];
	[dateComps setSecond:[timeComponents second]];
    
    NSLog(@"%d %d %d - %d:%d:%d", dateComps.day, dateComps.month, dateComps.year, dateComps.hour, dateComps.minute, dateComps.second);
    
    return [calendar dateFromComponents:dateComps];
}


@end
