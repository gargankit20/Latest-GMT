//
//  HomeViewController.h
//  FunnyBirthCard
//
//  Created by Ankit Garg on 5/5/20.
//  Copyright © 2020 Yusri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface HomeViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSMutableArray *smallThumbnailsArray;
    NSMutableArray *largeThumbnailsArray;
    NSMutableArray *likesCountArray;
    NSMutableArray *shortCodesArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *settingsView;

@end
