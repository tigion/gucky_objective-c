//
//  EyeSet.h
//  Gucky
//
//  Created by Christoph Zirkelbach on 26.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EyeSet : NSObject

// properties
@property CGFloat leftEyeDiameter, rightEyeDiameter;
@property NSColor *leftEyeEyeballColor, *leftEyeOutlineColor, *leftEyePupilColor;
@property NSColor *rightEyeEyeballColor, *rightEyeOutlineColor, *rightEyePupilColor;
@property CGFloat eyeSpace;
@property (getter = isEyeSync) BOOL eyeSync;

// A special initializer with one diameter for both eyes.
- (id)initWithLeftEyeDiameter:(CGFloat)aLeftEyeDiameter;

// A special initializer with two eye diameters.
- (id)initWithLeftEyeDiameter:(CGFloat)aLeftEyeDiameter
             rightEyeDiameter:(CGFloat)aRightEyeDiameter;

// A special initializer with all attributes.
- (id)initWithLeftEyeDiameter:(CGFloat)aLeftEyeDiameter
          leftEyeOutlineColor:(NSColor*)aLeftEyeOutlineColor
          leftEyeEyeballColor:(NSColor*)aLeftEyeEyeballColor
            leftEyePupilColor:(NSColor*)aLeftEyePupilColor
             rightEyeDiameter:(CGFloat)aRightEyeDiameter
         rightEyeOutlineColor:(NSColor*)aRightEyeOutlineColor
         rightEyeEyeballColor:(NSColor*)aRightEyeEyeballColor
           rightEyePupilColor:(NSColor*)aRightEyePupilColor
                     eyeSpace:(CGFloat)aEyeSpace
                      eyeSync:(BOOL)aEyeSync;

@end
