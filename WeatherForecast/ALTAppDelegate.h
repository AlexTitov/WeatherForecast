//
//  ALTAppDelegate.h
//  WeatherForecast
//
//  Created by Alexey Titov on 09/11/14.
//  Copyright (c) 2014 Alexey Titov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
