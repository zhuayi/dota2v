//
//  ZAppDelegate.h
//  daigou
//
//  Created by zhuayi on 5/11/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeveyTabBarController;
@class ASIDownloadCache;
@interface ZAppDelegate : UIResponder <UIApplicationDelegate>
{
    //UIWindow *window;
    LeveyTabBarController *leveyTabBarController;
    
    BOOL isguide ;
    
    //ASIDownloadCache *myCache;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



//@property (strong, nonatomic) DDMenuController * menuController;


@end
