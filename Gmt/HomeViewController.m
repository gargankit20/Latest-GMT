//
//  HomeViewController.m
//  FunnyBirthCard
//
//  Created by Ankit Garg on 5/5/20.
//  Copyright © 2020 Yusri. All rights reserved.
//

#import "HomeViewController.h"
#import "GetLikesViewController.h"
#import "FirstViewController.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "Toast+UIView.h"
#import "AFHTTPClient.h"
#import "ImageCell.h"
#import <StoreKit/StoreKit.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title=@"Get Likes";
    
    smallThumbnailsArray=[[NSMutableArray alloc] init];
    largeThumbnailsArray=[[NSMutableArray alloc] init];
    likesCountArray=[[NSMutableArray alloc] init];
    shortCodesArray=[[NSMutableArray alloc] init];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"userID"].length>0)
    {
        [self getAllPhotos];
    }
    else
    {
        LoginViewController *VC=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        VC.modalPresentationStyle=UIModalPresentationFullScreen;
        [self presentViewController:VC animated:YES completion:nil];
    }
}

-(IBAction)pressRate
{
    if(@available(iOS 10.3, *))
    {
        [SKStoreReviewController requestReview];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id10000000"] options:@{} completionHandler:nil];
    }
}

-(IBAction)pressLogout
{
    NSString *appDomain=NSBundle.mainBundle.bundleIdentifier;
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    FirstViewController *VC=[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    VC.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:VC animated:YES completion:nil];
}

-(IBAction)showHideSettingsView
{
    if([_settingsView isHidden])
    {
        [_settingsView setHidden:NO];
    }
    else
    {
        [_settingsView setHidden:YES];
    }
}

-(IBAction)pressEmail
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *MC=[[MFMailComposeViewController alloc] init];
        MC.mailComposeDelegate=self;
        [MC setSubject:@"Cool like"];
        [MC setMessageBody:@"Type here for the problems/issues you have in this app" isHTML:NO];
        [MC setToRecipients:@[@"2047636988@qq.com"]];
        [self presentViewController:MC animated:YES completion:NULL];
    }
    else
    {
        [self createAlertView:@"Something is going wrong" message:@"Please check if you have email added in Settings -> Mail, Contacts, Calendars"];
    }
}

-(void)createAlertView:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch(result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            [self failMail];
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)failMail
{
    [self createAlertView:@"Failed" message:@"Please try to send it again"];
}

-(void)getAllPhotos
{
    [self.view makeToastActivity];
    
    NSString *urlString=[[NSString stringWithFormat:@"https://www.instagram.com/graphql/query/?query_id=17888483320059182&variables={\"first\":100,\"id\":\"%@\"}", [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *baseURL=[NSURL URLWithString:urlString];
    
    AFHTTPClient *httpClient=[[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSMutableURLRequest *request=[httpClient requestWithMethod:@"GET" path:urlString parameters:nil];

    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];

    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self.view hideToastActivity];
        
        NSDictionary *responseDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *edgesArray=responseDic[@"data"][@"user"][@"edge_owner_to_timeline_media"][@"edges"];
        
        for(int i=0; i<edgesArray.count; i++)
        {
            [self->smallThumbnailsArray addObject:edgesArray[i][@"node"][@"thumbnail_resources"][0][@"src"]];
            [self->largeThumbnailsArray addObject:edgesArray[i][@"node"][@"thumbnail_resources"][2][@"src"]];
            [self->likesCountArray addObject:edgesArray[i][@"node"][@"edge_media_preview_like"][@"count"]];
            [self->shortCodesArray addObject:edgesArray[i][@"node"][@"shortcode"]];
        }
        
        [self->_collectionView reloadData];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
    [operation start];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return smallThumbnailsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell=(ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:smallThumbnailsArray[indexPath.row]];
    cell.likesLbl.text=[NSString stringWithFormat:@"%@", likesCountArray[indexPath.row]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GetLikesViewController *VC=[[GetLikesViewController alloc] initWithNibName:@"GetLikesViewController" bundle:nil];
    
    VC.imgUrl=largeThumbnailsArray[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((_collectionView.frame.size.width-10)/3, 130);
}

@end
