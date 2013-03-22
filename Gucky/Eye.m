//
//  Eye.m
//  Gucky
//
//  Created by Christoph Zirkelbach on 17.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import "Eye.h"

@implementation Eye

// init

- (id)init {
    self = [super init];
    if (self != nil) {
        self.diameter = 15;
        self->_outlineColor = [NSColor blackColor];
        self->_eyeballColor = [NSColor whiteColor];
        self->_pupilColor = [NSColor blackColor];
    }
    return self;
}

// special inits

- (id)initWithDiameter:(CGFloat)aDiameter {
    self = [self init];
    if (self != nil) {
        self.diameter = aDiameter;
    }
    return self;
}

- (id)initWithDiameter:(CGFloat)aDiameter
          outlineColor:(NSColor*)aOutlineColor
          eyeballColor:(NSColor*)aEyeballColor
            pupilColor:(NSColor*)aPupilColor {
    self = [self init];
    if (self != nil) {
        self.diameter = aDiameter;
        self.outlineColor = aOutlineColor;
        self.eyeballColor = aEyeballColor;
        self.pupilColor = aPupilColor;
    }
    return self;
}

// property accessor methods

- (void)setDiameter:(CGFloat)aDiameter {
    // limits (hard coded!)
    CGFloat max = 49;
    CGFloat min = 11;
    
    // check limits
    self->_diameter = (aDiameter > max) ? max : (aDiameter < min) ? min : aDiameter;
    
    // calculate dependent instance variables
    self->_pupilDiameter = self.diameter / 2.0f;
    self->_maxPupilDistance = (self.diameter / 2.0f) - (self.pupilDiameter / 2.0f) - 1;
}

@end
