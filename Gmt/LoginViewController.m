//
//  LoginViewController.m
//  FunnyBirthCard
//
//  Created by Ankit Garg on 5/5/20.
//  Copyright © 2020 Yusri. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "Toast+UIView.h"
#import "AFHTTPClient.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"Login";
    
    UIView *paddingView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _usernameTxt.leftView=paddingView;
    _usernameTxt.leftViewMode=UITextFieldViewModeAlways;
    
    _usernameTxt.text=@"rj1923";
}

-(IBAction)getUserID
{
    [_usernameTxt resignFirstResponder];
    
    if(_usernameTxt.text.length<1)
    {
        [self createAlertView:@"Message" message:@"Please enter user name"];
    }
    else
    {
        [self.view makeToastActivity];
        
        NSString *urlString=[NSString stringWithFormat:@"https://www.instagram.com/%@/?__a=1", _usernameTxt.text];
        NSURL *baseURL=[NSURL URLWithString:urlString];
        
        AFHTTPClient *httpClient=[[AFHTTPClient alloc] initWithBaseURL:baseURL];
        NSMutableURLRequest *request=[httpClient requestWithMethod:@"GET" path:urlString parameters:nil];
        
        AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
            [self.view hideToastActivity];
            
            NSDictionary *responseDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *userID=responseDic[@"graphql"][@"user"][@"id"];
            NSString *profilePicURL=responseDic[@"graphql"][@"user"][@"profile_pic_url_hd"];
            if(userID.length>0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
                [[NSUserDefaults standardUserDefaults] setObject:profilePicURL forKey:@"profilePicURL"];
                [[NSUserDefaults standardUserDefaults] setObject:self->_usernameTxt.text forKey:@"username"];
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
        }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
            
        }];
        [operation start];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)createAlertView:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
