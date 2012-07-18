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
#import "ImageTools.h"

#define DEFAULT_IMAGE_NAME  @"image"
#define INSTAGRAM_EXTENSION @"igo"
#define INSTAGRAM_UTI       @"com.instagram.exclusivegram"

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
