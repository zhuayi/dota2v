//
//  ZAppDelegate.m
//  daigou
//
//  Created by zhuayi on 5/11/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZAppDelegate.h"
#import "HomeTableViewController.h"
#import "ZCategoryViewController.h"
#import "ZProfiileTableViewController.h"
#import "ZFindTableViewController.h"
#import "ZMoreTableViewController.h"
#import "LeveyTabBarController.h"
#import "ZPlayViewController.h"
#import "EAIntroView.h"
#import "ZVideoTableViewController.h"
#import "MobClick.h"
#import "ZFuntion.h"
//友盟
#import "UMTableViewController.h"

@implementation ZAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"APP_WIDTH === %f",[UIScreen mainScreen].bounds.size.width);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //主页
    UINavigationController * Hometableview  = [[UINavigationController alloc] initWithRootViewController:[[HomeTableViewController alloc] init]];
        
    //收藏
    UINavigationController * Category  = [[UINavigationController alloc] initWithRootViewController:[[ZCategoryViewController alloc] init]];
    
    //个人中心
    UINavigationController * proFile  = [[UINavigationController alloc] initWithRootViewController:[[ZProfiileTableViewController alloc] init]];
    
    //发现
    //UINavigationController * findView  = [[UINavigationController alloc] initWithRootViewController:[[ZFindTableViewController alloc] init]];
    
    //更多
    //UINavigationController * moreView  = [[UINavigationController alloc] initWithRootViewController:[[ZMoreTableViewController alloc] init]];
    
    UINavigationController * moreView  = [[UINavigationController alloc] initWithRootViewController:[[UMTableViewController alloc] init]];
    
    NSArray * viewControllerArray = [NSArray arrayWithObjects:
                                                                Hometableview,
                                                                Category,
                                                                proFile,
                                                                //findView,
                                                                moreView,
                                                                //play,
                                                                nil
                                                            ];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:@"home_homepage_notselected"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:@"home_homepage_selected"] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:@"home_homepage_selected"] forKey:@"Selected"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"home_classify_notselected"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"home_classify"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"home_classify"] forKey:@"Selected"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"home_find_notselected"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"home_find_selected"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"home_find_selected"] forKey:@"Selected"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"tabbar_find_os7"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"tabbar_find_highlighted_os7"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"tabbar_find_highlighted_os7"] forKey:@"Selected"];
	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageNamed:@"home_mine_notselected"] forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageNamed:@"home_mine_selected"] forKey:@"Highlighted"];
	[imgDic5 setObject:[UIImage imageNamed:@"home_mine_selected"] forKey:@"Selected"];
	
	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic5,nil];
    
    
    leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:viewControllerArray imageArray:imgArr];
    //home_nav_bg
    [leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"hometarbar_bg"]];
	[leveyTabBarController setTabBarTransparent:NO];

    
    //背景色和状态栏设置
    if (IsIOS7)
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbarbg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName
                                                           , nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.rootViewController = leveyTabBarController;

    
    NSLog(@"launchOptions == %@",launchOptions);
    //******友盟测试设备 start
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    //******友盟测试设备 end
    
    [MobClick startWithAppkey:@"537b727756240b72b602a09c" reportPolicy:BATCH   channelId:@"dota"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version === %@",version);
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    //[MobClick checkUpdate];
    
    //推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [self.window makeKeyAndVisible];
    
    //[self get_device_info:@"aaaaa"];
    
    return YES;

}


//********************推送 START
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
    NSMutableDictionary * device_info = [ZFuntion get_device_info_list];
    [device_info setObject:token forKey:@"device_token"];
    
    NSDictionary * post_data = [[NSDictionary alloc] initWithObjectsAndKeys:[ZFuntion json_decode:device_info],@"post_data", nil];
    
    ZFuntion * zfunction = [[ZFuntion alloc] init];
    [zfunction push_device_info_to_server:PUSH_DEVICES_INFO post_data:post_data delegate:self];
    
    NSLog(@"device_info === %@",post_data);

}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if (error)
    {
        NSLog(@"error === %@",error);
    }
}
- ( void )requestFinished:( ASIHTTPRequest *)request
{
    
    NSString * responseString = [request responseString];
    NSLog(@"responseString === %@",responseString);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"frontia application:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"frontia applciation receive Notify: %@", [userInfo description]);
    if (application.applicationState == UIApplicationStateActive)
    {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dota2视频"
                                                            message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                            delegate:self
                                                            cancelButtonTitle:@"关闭"
                                                            otherButtonTitles:nil];
        [alertView show];
        
        if ([[userInfo objectForKey:@"aps"] objectForKey:@"vid"] != nil)
        {
            alertView.tag = [[[userInfo objectForKey:@"aps"] objectForKey:@"vid"] intValue];
           
            //leveyTabBarController.selectedIndex = 2;
        }
    }
    [application setApplicationIconBadgeNumber:0];
    
    
    //[FrontiaPush handleNotification:userInfo];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != nil)
    {
        ZVideoTableViewController * Video = [[ZVideoTableViewController alloc] init];
        Video.vid = alertView.tag;
        [(UINavigationController *)leveyTabBarController.selectedViewController pushViewController:Video animated:YES];
    }
}

//********************百度推送 END

//********************屏幕旋转 START
//ios5
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//
//{
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}
//
////ios6
//-(NSUInteger)supportedInterfaceOrientations
//
//{
//    return UIInterfaceOrientationMaskAll;
//}
//
- (BOOL)shouldAutorotate
{
        return NO;
}

//********************屏幕旋转 END


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



//应用开始时
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
    
   
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
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

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"daigou" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"daigou.sqlite"];
    
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


#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
