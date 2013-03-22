//
//  EyeFace.h
//  Gucky
//
//  Created by Christoph Zirkelbach on 17.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Eye;

// The EyeFace class hold the eyes, calculate the positions and
// create the needed images.
@interface EyeFace : NSObject {
    NSPoint saveLeftPupil, saveRightPupil;
}

// properties
@property Eye *leftEye, *rightEye;
@property CGFloat eyeSpace;
@property NSPoint origin, target;
@property (readonly) NSSize size;
@property (readonly) NSImage *eyeballImage, *pupilImage;

// A special initializer with left and right eye.
- (id)initWithLeftEye:(Eye*)aLeftEye rightEye:(Eye*)aRightEye;

// methods

// Calculates the face width.
- (CGFloat)calcWidth;

// Calculates the center of all eyes.
- (void)calcCenterForAllEyes;

// Calculates the viewing direction of the eyepupil for
// a given eye and target.
- (void)calcLookForEye:(Eye*)aEye withTarget:(NSPoint)aTarget;

// Calculates the viewing direction of the eyepupil for
// all eyes to a given target.
- (void)calcLookForAllEyesWithTarget:(NSPoint)aTarget;

// Creates an image with all eyeballs.
- (void)makeEyeballImage;

// Creates an image with all eyeballs and his pupils
- (void)makeEyeImage;

// Returns true, if a new image is created for a new target.
- (bool)isNewImageForTarget:(NSPoint)aTarget;

// Forces a new calculation and image creating.
- (void)forceRefresh:(NSPoint)aTarget;

// Synchronizes the right eye to the same values how the left eye.
- (void)syncEyes;

@end
