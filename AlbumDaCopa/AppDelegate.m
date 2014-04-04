//
//  AppDelegate.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 3/31/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "AppDelegate.h"
#import "Sticker.h"


@implementation AppDelegate

#pragma mark - SYNTHESIZE
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - LAUCHING OPTIONS
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"6ebKwAp10lhi98DnWAuWefQYGXijOwf09VOVKyNe" clientKey:@"g8Vd5jpXWPYmeCa7EDYG3VOEbFUmrDdh9drbQk1Z"];
    
    StickerTableViewController *stickerTableView = [[StickerTableViewController alloc] init];
    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:stickerTableView];
    navControl.navigationBar.translucent = NO;
    
    [self addObserver:stickerTableView forKeyPath:@"isFirstTime" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:EmailUserDefaultString]) {
        self.isFirstTime = NO;
    } else {
        [StickerController createAllStickersToDatabase];
        self.isFirstTime = YES;
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navControl;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - APPLCATION
-(void)applicationWillResignActive:(UIApplication *)application {
}
-(void)applicationDidEnterBackground:(UIApplication *)application {
}
-(void)applicationWillEnterForeground:(UIApplication *)application {
}
-(void)applicationDidBecomeActive:(UIApplication *)application {
    [self performSelector:@selector(sendNotificationToFullscrennAd) withObject:nil afterDelay:1];
    
}
-(void)sendNotificationToFullscrennAd {
    [[NSNotificationCenter defaultCenter] postNotificationName:FullscreenAdNotification object:nil];
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
