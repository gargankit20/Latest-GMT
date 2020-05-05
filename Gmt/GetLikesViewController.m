//
//  GetLikesViewController.m
//  FunnyBirthCard
//
//  Created by Ankit Garg on 5/5/20.
//  Copyright © 2020 Yusri. All rights reserved.
//

#import "GetLikesViewController.h"
#import "GetFollowersViewController.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPClient.h"
#import "GetLikesCell.h"
#import "Toast+UIView.h"

@interface GetLikesViewController ()

@end

@implementation GetLikesViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"Get Likes";
    
    dataArray=@[@20, @40, @80, @150, @300, @600, @1200, @2500, @5000];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imgUrl]];
    
    [_tableView registerNib:[UINib nibWithNibName:@"GetLikesCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self getLikesDelivered];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}

-(void)getLikesDelivered
{
    NSString *urlString=@"http://cutetstickers.co/temp_sticker_status_l.php";
    NSURL *baseURL=[NSURL URLWithString:urlString];
    
    AFHTTPClient *httpClient=[[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSMutableURLRequest *request=[httpClient requestWithMethod:@"GET" path:urlString parameters:nil];

    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];

    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *responseDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.likesLbl.text=[NSString stringWithFormat:@"Delivered Like count %@/%@", responseDic[@"delivered"], responseDic[@"totalOrdered"]];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
    [operation start];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetLikesCell *cell=(GetLikesCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
    if(indexPath.row==0)
    {
        [cell.getLikesBtn setTitle:@"Get Followers" forState:UIControlStateNormal];
        [cell.getLikesBtn setBackgroundColor:[self colorWithHex:0x78a840]];
        [cell.getLikesBtn addTarget:self action:@selector(getFollowers:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [cell.getLikesBtn setTitle:[NSString stringWithFormat:@"Get %@ Likes", [dataArray objectAtIndex:indexPath.row-1]] forState:UIControlStateNormal];
        [cell.getLikesBtn setBackgroundColor:[self colorWithHex:0x5ba899]];
        [cell.getLikesBtn addTarget:self action:@selector(openWebView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(void)getFollowers:(id)sender
{
    UIButton *button=(UIButton *)sender;
    [button setBackgroundColor:[UIColor colorWithRed:81.0/255.0 green:158.0/255.0 blue:143.0/255.0 alpha:1.0]];
                      
    GetFollowersViewController *VC=[[GetFollowersViewController alloc] initWithNibName:@"GetFollowersViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)openWebView:(id)sender
{
    UIButton *button=(UIButton *)sender;
    [button setBackgroundColor:[UIColor colorWithRed:92.0/255.0 green:175.0/255.0 blue:164.0/255.0 alpha:1.0]];
    
    NSData *data=[_imgUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded=[data base64EncodedStringWithOptions:0];
    
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:webView];
    webView.delegate=self;
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cutetstickers.co/get_sticker_l.php?userid=%@&img_url=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"], base64Encoded]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    [webView loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView makeToastActivity];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView hideToastActivity];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webView hideToastActivity];
}

-(UIColor *)colorWithHex:(long)hexColor
{
    float red=((float)((hexColor&0xFF0000)>>16))/255.0;
    float green=((float)((hexColor&0xFF00)>>8))/255.0;
    float blue=((float)(hexColor&0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
