//
//  EyeFace.m
//  Gucky
//
//  Created by Christoph Zirkelbach on 17.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import "EyeFace.h"
#import "EyeSet.h"
#import "Eye.h"

@implementation EyeFace

// inits

- (id)init {
    self = [super init];
    if (self != nil) {
        // check retina (HiDPI)
        isRetina = false;
        if ([[[NSScreen alloc] init] backingScaleFactor] == 2)
            isRetina = true;
        
        // init eyes
        self->_leftEye = [[Eye alloc] init];
        self->_rightEye = [[Eye alloc] init];
        self->_eyeSpace = 1;
        
        // calculate
        [self calcCenterForAllEyes];
        
        // create image background
        [self makeEyeballImage];
    }
    return self;
}

// special inits

- (id)initWithEyeSet:(EyeSet*)aEyeSet {
    self = [self init];
    if (self != nil) {
        // init eyes
        [self setEyesWithEyeSet:aEyeSet];
        
        // calculate
        [self calcCenterForAllEyes];
        
        // create image background
        [self makeEyeballImage];
    }
    return self;
}

// methods

- (void)setEyesWithEyeSet:(EyeSet*)aEyeSet {
    Eye *eyeL = [[Eye alloc] initWithDiameter:[aEyeSet leftEyeDiameter]
                                 outlineColor:[aEyeSet leftEyeOutlineColor]
                                 eyeballColor:[aEyeSet leftEyeEyeballColor]
                                   pupilColor:[aEyeSet leftEyePupilColor]];
    Eye *eyeR = [[Eye alloc] initWithDiameter:[aEyeSet rightEyeDiameter]
                                 outlineColor:[aEyeSet rightEyeOutlineColor]
                                 eyeballColor:[aEyeSet rightEyeEyeballColor]
                                   pupilColor:[aEyeSet rightEyePupilColor]];
    self.leftEye = eyeL;
    self.rightEye = eyeR;
    
    //self.eyeSync
    //self.eyeSpace
}

- (CGFloat)calcWidth {
    return [self.leftEye diameter] + self.eyeSpace + [self.rightEye diameter];
}

- (void)calcCenterForAllEyes {
    CGFloat x, y;
    
    // height: 21px = 22px status item - 1px black bottom line (hard coded!)
    // retina no/yes: 12px/22px, 0/0.5 
    self->_size = NSMakeSize([self calcWidth], ((isRetina) ? 22 : 21)); // retina dependent
    
    // left eye
    x = [self.leftEye diameter] / 2.0f;
    y = self.size.height / 2.0f - ((isRetina) ? 0.5 : 0); // retina dependent
    [self.leftEye setCenter:NSMakePoint(x, y)];
    
    // right eye
    x = [self.leftEye diameter] + self.eyeSpace + [self.rightEye diameter] / 2.0f;
    [self.rightEye setCenter:NSMakePoint(x, y)];
}

- (void)calcLookForEye:(Eye*)aEye withTarget:(NSPoint)aTarget {
    // Notes:
    // - convert radians to degrees: rad * 180 / M_PI
    // - convert degrees to radians: deg * M_PI / 180
    // - a: Gegenkathete
    // - b: Ankathete
    // - c: Hypotenuse
    
    // calc triangle edges
    CGFloat a = aTarget.x - (self.origin.x + [aEye center].x);
    CGFloat b = aTarget.y - (self.origin.y + [aEye center].y);
    CGFloat c = sqrtf((a * a) + (b * b));
    
    // calc angels
    CGFloat alpha = atanf(a / b) * 180.0f / M_PI;
    CGFloat alpha360 = alpha;
    CGFloat gamma = 90;
    if (a >= 0 && b < 0)
        alpha360 = 180 + alpha;
    else if (a < 0 && b < 0)
        alpha360 = 180 + alpha;
    else if (a < 0 && b >= 0)
        alpha360 = 180 + 180 + alpha;
    CGFloat beta = 180 - gamma - alpha360;
    
    // calc pupil triangle edges
    CGFloat pupilC = (c < [aEye maxPupilDistance]) ? c : [aEye maxPupilDistance];
    CGFloat pupilA = pupilC * sinf(alpha360 * M_PI / 180.0f) / sinf(gamma * M_PI / 180.0f);
    CGFloat pupilB = pupilC * sinf(beta * M_PI / 180.0f) / sinf(gamma * M_PI / 180.0f);
    
    // set result
    NSPoint pupilCenterRounded;
    pupilCenterRounded.x = ((CGFloat)((NSInteger)(pupilA * 10 + .5f))) / 10.0f;
    pupilCenterRounded.y = ((CGFloat)((NSInteger)(pupilB * 10 + .5f))) / 10.0f;
    [aEye setPupilCenter:pupilCenterRounded];
}

- (void)calcLookForAllEyesWithTarget:(NSPoint)aTarget {
    [self calcLookForEye:self.leftEye withTarget:aTarget];
    [self calcLookForEye:self.rightEye withTarget:aTarget];
}

- (void)makeEyeballImage {
    // init with size
    self->_eyeballImage = [[NSImage alloc] initWithSize:NSMakeSize(self.size.width, self.size.height)];
    
    // prepare path rects
    NSRect left = NSMakeRect([self.leftEye center].x - (([self.leftEye diameter] - 2) / 2.0f),
                             [self.leftEye center].y - (([self.leftEye diameter] - 2) / 2.0f),
                             [self.leftEye diameter] - 2,
                             [self.leftEye diameter] - 2);
    NSRect right = NSMakeRect([self.rightEye center].x - (([self.rightEye diameter] - 2) / 2.0f),
                              [self.rightEye center].y - (([self.rightEye diameter] - 2) / 2.0f),
                              [self.rightEye diameter] - 2,
                              [self.rightEye diameter] - 2);
    
    // let us drawing
    [self->_eyeballImage lockFocus];
    [[self.leftEye outlineColor] set];
    [[NSBezierPath bezierPathWithOvalInRect:left] stroke];
    [[self.rightEye outlineColor] set];
    [[NSBezierPath bezierPathWithOvalInRect:right] stroke];
    [[self.leftEye eyeballColor] set];
    [[NSBezierPath bezierPathWithOvalInRect:left] fill];
    [[self.rightEye eyeballColor] set];
    [[NSBezierPath bezierPathWithOvalInRect:right] fill];
    [self->_eyeballImage unlockFocus];
    
    // draw the image in the current context
    [self->_eyeballImage drawAtPoint: NSMakePoint(0.0, 0.0)
            fromRect: NSMakeRect(0.0, 0.0, [self->_eyeballImage size].width, [self->_eyeballImage size].height)
           operation: NSCompositeSourceOver
            fraction: 1.0];
}

- (void)makeEyeImage {
    // init with background image
    self->_pupilImage = [self.eyeballImage copy];
    
    // prepare path rects
    NSRect left = NSMakeRect([self.leftEye center].x + [self.leftEye pupilCenter].x - (([self.leftEye pupilDiameter] - 2) /2.0f),
                             [self.leftEye center].y + [self.leftEye pupilCenter].y - (([self.leftEye pupilDiameter] - 2) / 2.0f),
                             [self.leftEye pupilDiameter] - 2,
                             [self.leftEye pupilDiameter] - 2);
    NSRect right = NSMakeRect([self.rightEye center].x + [self.rightEye pupilCenter].x - (([self.rightEye pupilDiameter] - 2) /2.0f),
                              [self.rightEye center].y + [self.rightEye pupilCenter].y - (([self.rightEye pupilDiameter] - 2) / 2.0f),
                              [self.rightEye pupilDiameter] - 2,
                              [self.rightEye pupilDiameter] - 2);
    
    // let us drawing
    [self->_pupilImage lockFocus];
    [[self.leftEye pupilColor] set];
    [[NSBezierPath bezierPathWithOvalInRect:left] fill];
    [[self.rightEye pupilColor] set];
    [[NSBezierPath bezierPathWithOvalInRect:right] fill];
    [self->_pupilImage unlockFocus];
    
    // draw the image in the current context
    [self->_pupilImage drawAtPoint: NSMakePoint(0, 0)
                          fromRect: NSMakeRect(0, 0, [self->_pupilImage size].width, [self->_pupilImage size].height)
                         operation: NSCompositeSourceOver
                          fraction: 1.0];
}

- (bool)isNewImageForTarget:(NSPoint)aTarget {
    // calculate
    [self calcLookForAllEyesWithTarget:aTarget];
    
    // check if new pupil position
    if ([self.leftEye pupilCenter].x == self->saveLeftPupil.x && [self.leftEye pupilCenter].y == self->saveLeftPupil.y &&
        [self.rightEye pupilCenter].x == self->saveRightPupil.x && [self.rightEye pupilCenter].y == self->saveRightPupil.y)
        return false;
    
    // save pupil positions
    self->saveLeftPupil = [self.leftEye pupilCenter];
    self->saveRightPupil = [self.rightEye pupilCenter];
    
    // make image
    [self makeEyeImage];
    
    return true;
}

- (void)forceRefresh:(NSPoint)aTarget {
    [self calcCenterForAllEyes];
    //if (aTarget.x != 0 || aTarget.y != 0)
    [self calcLookForAllEyesWithTarget:aTarget];
    [self makeEyeballImage];
    [self makeEyeImage];
}

- (void)syncEyes {
    [self.rightEye setDiameter:[self.leftEye diameter]];
    [self.rightEye setOutlineColor:[self.leftEye outlineColor]];
    [self.rightEye setEyeballColor:[self.leftEye eyeballColor]];
    [self.rightEye setPupilColor:[self.leftEye pupilColor]];
}

@end
