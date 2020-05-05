//
//  GetLikesViewController.h
//  FunnyBirthCard
//
//  Created by Ankit Garg on 5/5/20.
//  Copyright © 2020 Yusri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetLikesViewController : UIViewController<UIWebViewDelegate>
{
    NSArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *likesLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *imgUrl;

@end
