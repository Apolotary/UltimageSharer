//
//  RecipientChooserViewController.m
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 7/19/12.
//  Copyright (c) 2012 sibers. All rights reserved.
//

#import "RecipientChooserViewController.h"

@implementation RecipientChooserViewController

@synthesize imageToSend = _imageToSend;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark HUD methods

- (void) freezeInterface
{
    // Add HUD to screen    
    [_hud setFrame:CGRectMake(0, 0, 320, 431)];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_hud];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    _hud.delegate = self;
	
    _hud.labelText = @"Loading";
	[_hud show:YES];
}

- (void) unFreezeInterface
{
    [_hud removeFromSuperview];
}

- (void)hudWasHidden
{
    
}

#pragma mark - Twitter methods

- (void) sendTweetWithText: (NSString *) text
                  andImage: (UIImage *) image
{
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:text];
    [tweetViewController addImage:image];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        [self dismissModalViewControllerAnimated:YES];
        [self unFreezeInterface];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
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

- (NSURL *) saveAndGetPathForImage: (UIImage *) image 
                     withExtension: (NSString *) extension
{
    [ImageTools saveImage:_imageToSend withName:DEFAULT_IMAGE_NAME andExtension:extension];
    return [ImageTools getURLForImageNamed:DEFAULT_IMAGE_NAME withExtension:extension];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        // handle error
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self unFreezeInterface];
    }
}

#pragma mark - TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [_namesApps count];
            break;
        case 1:
            return [_namesSocialNetworks count];
            break;
        case 2:
            return [_namesImageHostings count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    switch (indexPath.section) 
    {
        case 0:
            [cell.textLabel setText:[_namesApps objectAtIndex:indexPath.row]];
            break;
        case 1:
            [cell.textLabel setText:[_namesSocialNetworks objectAtIndex:indexPath.row]];
            break;
        case 2:
            [cell.textLabel setText:[_namesImageHostings objectAtIndex:indexPath.row]];
            break;
        default:
            [cell.textLabel setText:@"not available"];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_namesGroups objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) // apps 
    {
        NSString *appName = [_namesApps objectAtIndex:indexPath.row];
        
        if ([appName isEqualToString:@"Instagram"])
        {
            NSURL *fileURL = [self saveAndGetPathForImage:_imageToSend withExtension:INSTAGRAM_EXTENSION];
            [self setupControllerWithURL:fileURL usingDelegate:self];
            [_documentInteractionController setUTI:INSTAGRAM_UTI];
            [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        }
        else if ([appName isEqualToString:@"Dropbox / all image apps"])
        {
            NSURL *fileURL = [self saveAndGetPathForImage:_imageToSend withExtension:DEFAULT_IMAGE_EXTENSION];
            [self setupControllerWithURL:fileURL usingDelegate:self];
            [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        }
        else if ([appName isEqualToString:@"Photo Library"])
        {
            [self freezeInterface];
            [ImageTools writeImage:_imageToSend toPhotoLibraryWithTarget:self andSelector:@selector(image:didFinishSavingWithError:contextInfo:)];
        }
    }
    else if (indexPath.section == 1) // networks
    {
        NSString *networkName = [_namesSocialNetworks objectAtIndex:indexPath.row];
        
        if ([networkName isEqualToString:@"Twitter"])
        {
            [self freezeInterface];
            [self sendTweetWithText:APP_DEFAULT_MESSAGE_TEXT andImage:_imageToSend];
        }
        else if ([networkName isEqualToString:@"Facebook"])
        {
            
        }
        else if ([networkName isEqualToString:@"tumblr"])
        {
            
        }
        else if ([networkName isEqualToString:@"Flickr"])
        {
            
        }
    }
    else if (indexPath.section == 2) // hostings
    {
        NSString *hostingName = [_namesImageHostings objectAtIndex:indexPath.row];
        
        if ([hostingName isEqualToString:@"imgur"])
        {
            
        }
        else if ([hostingName isEqualToString:@"yfrog"])
        {
            
        }
        else if ([hostingName isEqualToString:@"twitpic"])
        {
            
        }
        else if ([hostingName isEqualToString:@"imageshack"])
        {
            
        }
    }
}

#pragma mark - Names arrays method

- (void) initializeNamesArrays
{
    _namesGroups = [NSArray arrayWithObjects:@"Apps", @"Social Networks", @"Image hosting services", nil];
    _namesApps = [NSArray arrayWithObjects:@"Instagram", @"Dropbox / all image apps", @"Photo Library", nil];
    _namesSocialNetworks = [NSArray arrayWithObjects:@"Twitter", @"Facebook", @"tumblr", @"Flickr", nil];
    _namesImageHostings = [NSArray arrayWithObjects:@"imgur", @"yfrog", @"twitpic", @"imageshack", nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeNamesArrays];
    
    _hud = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
