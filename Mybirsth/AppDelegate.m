//
//  AppDelegate.m
//  Mybirsth
//
//  Created by slow on 2018/12/12.
//  Copyright © 2018年 slow Yusri. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *appDomain=NSBundle.mainBundle.bundleIdentifier;
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor grayColor];
    
    FirstViewController *VC=[[FirstViewController alloc] init];
    self.window.rootViewController=VC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application
{
 
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
   
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
