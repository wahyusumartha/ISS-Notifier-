//
//  WSLocalNotificationScheduler.m
//  ISS-Spot
//
//  Created by Wahyu Sumartha  on 4/21/13.
//  Copyright (c) 2013 Wahyu Sumartha . All rights reserved.
//

#import "WSLocalNotificationScheduler.h"

@implementation WSLocalNotificationScheduler

@synthesize badgeCount = _badgeCount;

+ (id)sharedInstance
{
    static WSLocalNotificationScheduler *sharedMyInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    
    return sharedMyInstance;
}

- (void)scheduleNotificationOn:(NSDate *)fireDate text:(NSString *)alertText action:(NSString *)alertAction sound:(NSString *)soundfileName launchImage:(NSString *)launchImage andInfo:(NSDictionary *)userInfo
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
    
    if (soundfileName == nil) localNotification.soundName = UILocalNotificationDefaultSoundName;
    else localNotification.soundName = soundfileName;
    
    localNotification.alertLaunchImage = launchImage;
    
    self.badgeCount++;
    localNotification.applicationIconBadgeNumber = self.badgeCount;
    localNotification.userInfo = userInfo;
    
    // schedule it with the app
    [[UIApplication sharedApplication] scheduledLocalNotifications];
    localNotification = nil;
}

- (void)clearBadgeCount
{
    self.badgeCount = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void)decreaseBadgeCountBy:(int)count
{
    self.badgeCount -= count;
    
    if (self.badgeCount < 0) self.badgeCount = 0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void)handleReceivedNotification:(UILocalNotification *)thisNotification
{
    [self decreaseBadgeCountBy:1];
}

@end
