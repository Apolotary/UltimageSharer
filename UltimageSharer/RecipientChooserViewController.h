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
#import "ImageTools.h"

#define DEFAULT_IMAGE_NAME      @"image"
#define DEFAULT_IMAGE_EXTENSION @"jpg"

#define INSTAGRAM_EXTENSION     @"igo"
#define INSTAGRAM_UTI           @"com.instagram.exclusivegram"

#define APP_DEFAULT_MESSAGE_TEXT @"Image sent with UltimageSharer, check out its source code at: https://github.com/Apolotary/UltimageSharer"

@interface RecipientChooserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate>
{
    IBOutlet UITableView *_tableView;
    UIImage *_imageToSend;
    NSArray *_namesGroups;
    NSArray *_namesApps;
    NSArray *_namesSocialNetworks;
    NSArray *_namesImageHostings;
    
    UIDocumentInteractionController *_documentInteractionController;
}

@property (nonatomic, strong) UIImage *imageToSend;

@end
