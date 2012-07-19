//
//  RecipientChooserViewController.h
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 7/19/12.
//  Copyright (c) 2012 sibers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import "ImageTools.h"
#import "MBProgressHUD.h"
#import "FacebookModel.h"

@interface RecipientChooserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>
{
    IBOutlet UITableView *_tableView;
    UIImage *_imageToSend;
    NSArray *_namesGroups;
    NSArray *_namesApps;
    NSArray *_namesSocialNetworks;
    NSArray *_namesImageHostings;
    
    UIDocumentInteractionController *_documentInteractionController;
    MBProgressHUD *_hud;
    FacebookModel *_fbModel;
    MFMailComposeViewController *_mailComposer;
}

@property (nonatomic, strong) UIImage *imageToSend;

@end
