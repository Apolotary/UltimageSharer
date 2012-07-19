//
//  MainViewController.h
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 17/07/2012.
//  Copyright (c) 2012 sibers. All rights reserved.
//
//  

#import <UIKit/UIKit.h>
#import "AFPhotoEditorController.h"
#import "RecipientChooserViewController.h"

typedef enum {
    kImageWorkingModeOpening = 1,
    kImageWorkingModeSharing = 2,
    kImageWorkingModeUnknown = 3
} ImageWorkingMode;

@interface MainViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,  AFPhotoEditorControllerDelegate>
{
    IBOutlet UIImageView *_mainImageView;
    UIImage *_imageToWorkWith;
    ImageWorkingMode _imageWorkingMode;
    UIImagePickerController *_imagePicker;
    BOOL _isCameraAvailable;
    BOOL _isPhotoLibraryAvailable;
}

@end
