//
//  EyeSet.m
//  Gucky
//
//  Created by Christoph Zirkelbach on 26.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import "EyeSet.h"

@implementation EyeSet

// init

- (id)init {
    self = [super init];
    if (self != nil) {
        self.leftEyeDiameter = 19;
        self.leftEyeOutlineColor = [NSColor blackColor];
        self.leftEyeEyeballColor = [NSColor whiteColor];
        self.leftEyePupilColor = [NSColor blackColor];
        self.rightEyeDiameter = self.leftEyeDiameter;
        self.rightEyeOutlineColor = self.leftEyeOutlineColor;
        self.rightEyeEyeballColor = self.leftEyeEyeballColor;
        self.rightEyePupilColor = self.leftEyePupilColor;
        self.eyeSpace = 1;
        self.eyeSync = TRUE;
    }
    return self;
}

// special inits

- (id)initWithLeftEyeDiameter:(CGFloat)aLeftEyeDiameter {
    self = [self init];
    if (self != nil) {
        self.leftEyeDiameter = aLeftEyeDiameter;
        self.rightEyeDiameter = aLeftEyeDiameter;
        self.eyeSync = TRUE;
    }
    return self;
}

- (id)initWithLeftEyeDiameter:(CGFloat)aLeftEyeDiameter
             rightEyeDiameter:(CGFloat)aRightEyeDiameter {
    self = [self init];
    if (self != nil) {
        self.leftEyeDiameter = aLeftEyeDiameter;
        self.rightEyeDiameter = aRightEyeDiameter;
        self.eyeSync = FALSE;
    }
    return self;
}

- (id)initWithLeftEyeDiameter:(CGFloat)aLeftEyeDiameter
          leftEyeOutlineColor:(NSColor*)aLeftEyeOutlineColor
          leftEyeEyeballColor:(NSColor*)aLeftEyeEyeballColor
            leftEyePupilColor:(NSColor*)aLeftEyePupilColor
             rightEyeDiameter:(CGFloat)aRightEyeDiameter
         rightEyeOutlineColor:(NSColor*)aRightEyeOutlineColor
         rightEyeEyeballColor:(NSColor*)aRightEyeEyeballColor
           rightEyePupilColor:(NSColor*)aRightEyePupilColor
                     eyeSpace:(CGFloat)aEyeSpace
                      eyeSync:(BOOL)aEyeSync {
    self = [self init];
    if (self != nil) {
        self.leftEyeDiameter = aLeftEyeDiameter;
        self.leftEyeOutlineColor = aLeftEyeOutlineColor;
        self.leftEyeEyeballColor = aLeftEyeEyeballColor;
        self.leftEyePupilColor = aLeftEyePupilColor;
        self.rightEyeDiameter = aRightEyeDiameter;
        self.rightEyeOutlineColor = aRightEyeOutlineColor;
        self.rightEyeEyeballColor = aRightEyeEyeballColor;
        self.rightEyePupilColor = aRightEyePupilColor;
        self.eyeSpace = aEyeSpace;
        self.eyeSync = aEyeSync;
    }
    return self;
}

// methods

-(id) copyWithZone: (NSZone *) zone
{
    EyeSet *copy = [[EyeSet allocWithZone: zone] init];
    
    [copy setLeftEyeDiameter:self.leftEyeDiameter];
    [copy setLeftEyeOutlineColor:self.leftEyeOutlineColor];
    [copy setLeftEyeEyeballColor:self.leftEyeEyeballColor];
    [copy setLeftEyePupilColor:self.leftEyePupilColor];
    [copy setRightEyeDiameter:self.rightEyeDiameter];
    [copy setRightEyeOutlineColor:self.rightEyeOutlineColor];
    [copy setRightEyeEyeballColor:self.rightEyeEyeballColor];
    [copy setRightEyePupilColor:self.rightEyePupilColor];
    [copy setEyeSync:self.eyeSync];
    [copy setEyeSpace:self.eyeSpace];
    
    return copy;
}

@end
