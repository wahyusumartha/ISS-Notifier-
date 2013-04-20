//
//  WSLocalNotificationScheduler.h
//  ISS-Spot
//
//  Created by Wahyu Sumartha  on 4/21/13.
//  Copyright (c) 2013 Wahyu Sumartha . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSLocalNotificationScheduler : NSObject

+ (id)sharedInstance;

- (void) scheduleNotificationOn:(NSDate*) fireDate
						   text:(NSString*) alertText
						 action:(NSString*) alertAction
						  sound:(NSString*) soundfileName
					launchImage:(NSString*) launchImage
						andInfo:(NSDictionary*) userInfo;

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification;

- (void) decreaseBadgeCountBy:(int) count;
- (void) clearBadgeCount;

@property (nonatomic, assign) int badgeCount;

@end
