//
//  FacebookModel.m
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 7/19/12.
//  Copyright (c) 2012 sibers. All rights reserved.
//

#import "FacebookModel.h"

@implementation FacebookModel

- (id)init {
    self = [super init];
    if (self) {
        _facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_KEY andDelegate:self];
    }
    return self;
}

#pragma mark - Login and session methods

- (void) facebookAuthorize
{
    DLog(@"CALLING FACEBOOK AUTHORIZE");
    // Check and retrieve authorization information
    
    NSArray * neededPermissions = [[NSArray alloc] initWithObjects:@"user_about_me", @"publish_stream", @"user_photos", nil];
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:FACEBOOK_ACCESS_TOKEN_SAVING_KEY] && [defaults objectForKey:FACEBOOK_EXPIRATION_SAVING_KEY]) {
        _facebook.accessToken = [defaults objectForKey:FACEBOOK_ACCESS_TOKEN_SAVING_KEY];
        _facebook.expirationDate = [defaults objectForKey:FACEBOOK_EXPIRATION_SAVING_KEY];
    }
    
    if (![_facebook isSessionValid]) {
        [_facebook authorize:neededPermissions];
    }
}

- (void) facebookLogout
{
    DLog(@"CALLING FACEBOOK LOGOUT");
    [_facebook logout];
}

- (void)fbDidLogin
{
    NSLog(@"LOGGED IN!");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:FACEBOOK_ACCESS_TOKEN_SAVING_KEY];
    [defaults setObject:[_facebook expirationDate] forKey:FACEBOOK_EXPIRATION_SAVING_KEY];
    [defaults synchronize];
}

- (void)fbDidLogout
{
    // do nothing
}

- (void)fbSessionInvalidated
{
    
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}

- (BOOL) isUserAlreadyAuthorizedViaFacebook
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:FACEBOOK_ACCESS_TOKEN_SAVING_KEY] && [defaults objectForKey:FACEBOOK_EXPIRATION_SAVING_KEY])
    {
        return YES;
    }
    return NO;
}

#pragma mark - Posting image

-(void) postImageToFacebookAlbum:(UIImage *)image
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   image, @"source", 
                                   APP_DEFAULT_MESSAGE_TEXT, @"message",             
                                   nil];
    
    [_facebook requestWithGraphPath:[NSString stringWithFormat:@"/me/photos?access_token=%@", _facebook.accessToken]
                         andParams:params andHttpMethod:@"POST" 
                        andDelegate:self];
}

#pragma mark - Request methods

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received response! %@", [response URL]);
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"Request didLoad: %@ ", [request url ]);
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result isKindOfClass:[NSDictionary class]]){
        
    }
    if ([result isKindOfClass:[NSData class]]) {
    }
    NSLog(@"request returns %@",result);
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"AAAAAAAA I FAILED WITH ERROR %@", error);
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    
}


@end
