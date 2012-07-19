//
//  FacebookModel.h
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 7/19/12.
//  Copyright (c) 2012 sibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FacebookModel : NSObject <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>
{
    Facebook *_facebook;
}

- (void) facebookAuthorize;
- (void) facebookLogout;
- (void) postImageToFacebookAlbum:(UIImage *)image;
- (BOOL) isUserAlreadyAuthorizedViaFacebook;

@end
