//
//  AppDelegate.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 3/31/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "AppDelegate.h"
#import "Sticker.h"
#import <AdColony/AdColony.h>

#define ADCOLONY__APPID @"app7c272267bce04bcfbd"
#define ADCOLONY__ZONE @"vz5be979460cde4b7c8f"

#define PARSE__APPID @"6ebKwAp10lhi98DnWAuWefQYGXijOwf09VOVKyNe"
#define PARSE__CLIENTKEY @"g8Vd5jpXWPYmeCa7EDYG3VOEbFUmrDdh9drbQk1Z"


@implementation AppDelegate

#pragma mark - SYNTHESIZE
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - LAUCHING OPTIONS
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:PARSE__APPID clientKey:PARSE__CLIENTKEY];
    [AdColony configureWithAppID:ADCOLONY__APPID zoneIDs:@[ADCOLONY__ZONE] delegate:nil logging:YES];
    
    StickerTableViewController *stickerTableView = [[StickerTableViewController alloc] init];
    TradeViewController *tradeViewController = [[TradeViewController alloc] init];
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = @[stickerTableView, tradeViewController];
    
    [self checkIfFirstTimeForTableViewObserver:stickerTableView];
    [AdColony playVideoAdForZone:ADCOLONY__ZONE withDelegate:nil];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)checkIfFirstTimeForTableViewObserver:(UIViewController *)view {
    [self addObserver:view forKeyPath:@"isFirstTime" options:NSKeyValueObservingOptionNew context:nil];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:NotFirstTime]) {
        self.isFirstTime = NO;
    } else {
        [StickerController createAllStickersToDatabase];
        self.isFirstTime = YES;
    }
}

#pragma mark - APPLCATION
-(void)applicationWillResignActive:(UIApplication *)application {
}
-(void)applicationDidEnterBackground:(UIApplication *)application {
}
-(void)applicationWillEnterForeground:(UIApplication *)application {
}
-(void)applicationDidBecomeActive:(UIApplication *)application {
    
}

-(void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}
-(void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - CORE DATA
+(NSManagedObjectContext *)staticManagedObjectContext {
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [del managedObjectContext];
}
-(NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
-(NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AlbumDaCopa" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AlbumDaCopa.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}
-(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
