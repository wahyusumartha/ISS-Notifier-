//
//  AppDelegate.h
//  ISS-Spot
//
//  Created by Wahyu Sumartha  on 4/20/13.
//  Copyright (c) 2013 Wahyu Sumartha . All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) MainViewController *mainViewController;

@property (strong, nonatomic) NSString *deviceToken;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
