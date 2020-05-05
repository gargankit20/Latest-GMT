//
//  FirstViewController.m
//  FunnyBirthCard
//
//  Created by Ankit Garg on 5/5/20.
//  Copyright © 2020 Yusri. All rights reserved.
//

#import "FirstViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(IBAction)clickGetLikes
{
    HomeViewController *VC=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:VC];
    [navigationController.navigationBar setTranslucent:NO];
    
    AppDelegate *newDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    newDelegate.window.rootViewController=navigationController;
    [newDelegate.window makeKeyAndVisible];
}

@end
