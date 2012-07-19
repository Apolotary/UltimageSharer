//
//  ImageTools.h
//  UltimageSharer
//
//  Created by Bektur Ryskeldiev on 17/07/2012.
//  Copyright (c) 2012 sibers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTools : NSObject

+ (void) saveImage: (UIImage *) image
          withName: (NSString *) name
      andExtension: (NSString *) extension;

+ (NSURL *) getURLForImageNamed: (NSString *) name
                  withExtension: (NSString *) extension;

+ (void) writeImage: (UIImage *) image toPhotoLibraryWithTarget: (id) target
        andSelector: (SEL) selector;

@end
