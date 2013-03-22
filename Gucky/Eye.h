//
//  Eye.h
//  Gucky
//
//  Created by Christoph Zirkelbach on 17.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import <Foundation/Foundation.h>

// The Eye class represents an simple eye.
@interface Eye : NSObject

// properties
@property (nonatomic) CGFloat diameter;
@property NSColor *outlineColor, *eyeballColor, *pupilColor;
@property NSPoint center, pupilCenter;
@property (readonly) CGFloat pupilDiameter, maxPupilDistance;

// A special initializer with eye diameter.
- (id)initWithDiameter:(CGFloat)aDiameter;

// A special initializer with eye diameter, outline color,
// eyeball color and pupil color.
- (id)initWithDiameter:(CGFloat)aDiameter
          outlineColor:(NSColor*)aOutlineColor
          eyeballColor:(NSColor*)aEyeballColor
            pupilColor:(NSColor*)aPupilColor;

// A custom property accessor method. Check the diameter limits and
// calculate the pupil diameter and the max distance to the center.
- (void)setDiameter:(CGFloat)aDiameter;

@end
