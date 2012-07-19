//
//  MainViewController.h
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 17/07/2012.
//  Copyright (c) 2012 sibers. All rights reserved.
//
//  

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "AFPhotoEditorController.h"
#import "ImageTools.h"


#define DEFAULT_IMAGE_NAME      @"image"
#define DEFAULT_IMAGE_EXTENSION @"jpg"

#define INSTAGRAM_EXTENSION     @"igo"
#define INSTAGRAM_UTI           @"com.instagram.exclusivegram"

#define APP_DEFAULT_MESSAGE_TEXT @"Image sent with UltimageSharer, check out its source code at: https://github.com/Apolotary/UltimageSharer"

typedef enum {
    kImageWorkingModeOpening = 1,
    kImageWorkingModeSharing = 2,
    kImageWorkingModeUnknown = 3
} ImageWorkingMode;

@interface MainViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate, AFPhotoEditorControllerDelegate>
{
    IBOutlet UIImageView *_mainImageView;
    UIImage *_imageToWorkWith;
    ImageWorkingMode _imageWorkingMode;
    UIImagePickerController *_imagePicker;
    UIDocumentInteractionController *_documentInteractionController;
    BOOL _isCameraAvailable;
    BOOL _isPhotoLibraryAvailable;
}

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@end
