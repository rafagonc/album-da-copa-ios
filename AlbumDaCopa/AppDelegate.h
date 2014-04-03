//
//  AppDelegate.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 3/31/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerTableViewController.h"

#define FullscreenAdNotification @"fullscreenad"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;
+(NSManagedObjectContext *)staticManagedObjectContext;

@end
