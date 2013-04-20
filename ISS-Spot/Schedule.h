//
//  Schedule.h
//  ISS-Spot
//
//  Created by Wahyu Sumartha  on 4/20/13.
//  Copyright (c) 2013 Wahyu Sumartha . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject

@property (nonatomic, assign) NSInteger durationRawDataInSeconds;
@property (nonatomic, assign) NSInteger riseTimeInTimeStamp;

@property (nonatomic, strong, readonly) NSString *duration;
@property (nonatomic, strong, readonly) NSString *riseTime;

@property (nonatomic, assign, readonly) NSInteger durationInHour;
@property (nonatomic, assign, readonly) NSInteger durationInMinutes;
@property (nonatomic, assign, readonly) NSInteger durationInSecond;

@property (nonatomic, strong, readonly) NSString *dateOfRiseTime;
@property (nonatomic, strong, readonly) NSString *monthOfRiseTime;
@property (nonatomic, strong, readonly) NSString *yearOfRiseTime;
@property (nonatomic, assign, readonly) NSInteger hourOfRiseTime;
@property (nonatomic, assign, readonly) NSInteger minutesOfRiseTime;
@property (nonatomic, assign, readonly) NSInteger secondOfRiseTime;


@end
