//
//  ImageTools.m
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 17/07/2012.
//  Copyright (c) 2012 sibers. All rights reserved.
//

#import "ImageTools.h"

@implementation ImageTools


+ (void) saveImage: (UIImage *) image
          withName: (NSString *) name
      andExtension: (NSString *) extension
{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",cacheDir, name, extension];
    NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    NSError *error;
    [data1 writeToFile:filePath options:NSDataWritingFileProtectionNone error:&error];
}

+ (NSURL *) getURLForImageNamed: (NSString *) name
                  withExtension: (NSString *) extension
{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",cacheDir, name, extension];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    return url;
}

@end
