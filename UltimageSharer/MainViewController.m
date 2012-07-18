//
//  MainViewController.m
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 17/07/2012.
//  Copyright (c) 2012 sibers. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize documentInteractionController = _documentInteractionController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ImagePicker actionsheet methods

- (void) showCameraImagePickerController
{
    _imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
    _imagePicker.delegate = self;
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    NSArray *photoMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"image"]];
    
    _imagePicker.mediaTypes = photoMediaTypesOnly;
    
    // Show image picker
    [self presentModalViewController:_imagePicker animated:YES];
}

- (void) showPhotoLibraryImagePickerController
{
    _imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Delegate is self
    _imagePicker.delegate = self;
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    NSArray *photoMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"image"]];
    
    _imagePicker.mediaTypes = photoMediaTypesOnly;
    
    // Show image picker
    [self presentModalViewController:_imagePicker animated:YES];
}

#pragma mark - Showing Aviary controller

- (void) showAviaryPhotoEditorWithImage: (UIImage *) image
{
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:image];
    [editorController setDelegate:self];
    [self presentModalViewController:editorController animated:YES];
}

#pragma mark - Showing Document Interaction controller

- (void) setupControllerWithURL: (NSURL *) fileURL
                  usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate 
{
    _documentInteractionController =
    [[UIDocumentInteractionController alloc] init];
    [_documentInteractionController setURL:fileURL];
    
    _documentInteractionController.delegate = interactionDelegate;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application
{
    NSLog(@"%@", application);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
{
    
}

-(void)documentInteractionControllerDidDismissOpenInMenu: (UIDocumentInteractionController *)controller 
{
    
}

#pragma mark - Saving images methods

- (NSURL *) saveImageForInstagramAndGetPath: (UIImage *) image
{
    [ImageTools saveImage:_imageToWorkWith withName:DEFAULT_IMAGE_NAME andExtension:INSTAGRAM_EXTENSION];
    return [ImageTools getURLForImageNamed:DEFAULT_IMAGE_NAME withExtension:INSTAGRAM_EXTENSION];
}

#pragma mark - UIImagePicker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo 
{
    [picker dismissViewControllerAnimated:YES completion:^(void){
        _imageToWorkWith = image;
        [_mainImageView setImage:image];
    }];
}

#pragma mark - Aviary Delegate methods

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [editor dismissViewControllerAnimated:YES completion:^(void){
        [_mainImageView setImage:image];
        _imageToWorkWith = image;
    }];
}

#pragma mark - ActionSheet Delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_imageWorkingMode == kImageWorkingModeOpening) // selecting image from picker
    {
        if (_isCameraAvailable)
        {
            if (buttonIndex == 0) // camera
            {
                [self showCameraImagePickerController];
            }
            else if (buttonIndex == 1) // photo library
            {
                [self showPhotoLibraryImagePickerController];
            }
        }
        else
        {
            if (buttonIndex == 0) // photo library
            {
                [self showPhotoLibraryImagePickerController];
            }
        }
    }
    else if (_imageWorkingMode == kImageWorkingModeSharing)
    {
        if (_imageToWorkWith != nil)
        {
            if (buttonIndex == 0) // aviary
            {
                [self showAviaryPhotoEditorWithImage:_imageToWorkWith];
            }
            else if (buttonIndex == 1) // Instagram
            {
                NSURL *fileURL = [self saveImageForInstagramAndGetPath:_imageToWorkWith];
                [self setupControllerWithURL:fileURL usingDelegate:self];
                [_documentInteractionController setUTI:INSTAGRAM_UTI];
                [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            }
        }
    }
}

#pragma mark - NavigationBar buttons methods

- (void) openButtonPressed
{
    _imageWorkingMode = kImageWorkingModeOpening;
    
    if (_isCameraAvailable && _isPhotoLibraryAvailable)
    {
        UIActionSheet *openWithCameraActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
        [openWithCameraActionSheet showInView:self.view];
    }
    else if (_isPhotoLibraryAvailable)
    {
        UIActionSheet *openWithoutCameraActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", nil];
        [openWithoutCameraActionSheet showInView:self.view];
    }
}

- (void) shareButtonPressed
{
    _imageWorkingMode = kImageWorkingModeSharing;

    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit in Aviary", @"Instagram", nil];
    [shareActionSheet showInView:self.view];
}

#pragma mark - NavigationBar initialization methods

- (void) initNavBarWithButtons
{
    UIBarButtonItem *openButton = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStyleBordered target:self action:@selector(openButtonPressed)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed)];
    
    [self.navigationItem setLeftBarButtonItem:openButton];
    [self.navigationItem setRightBarButtonItem:shareButton];
}

#pragma mark - ImagePicker and Picker flags methods

- (void) initImagePickerAndSetFlags
{
    _imageWorkingMode = kImageWorkingModeUnknown;
    _imagePicker = [[UIImagePickerController alloc] init];
    _isCameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    _isPhotoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initImagePickerAndSetFlags];
	[self.navigationController setNavigationBarHidden:NO];
    [self initNavBarWithButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
