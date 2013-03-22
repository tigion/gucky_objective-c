//
//  Preferences.m
//  Gucky
//
//  Created by Christoph Zirkelbach on 19.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

// init

- (id)init {
    self = [super init];
    if (self != nil) {
        // left eye defaults
        self->_leftEyeDiameter = 19.0f;
        self->_leftEyeOutlineColor = [NSColor blackColor];
        self->_leftEyeColor = [NSColor whiteColor];
        self->_leftEyePupilColor = [NSColor blackColor];
        // right eye defaults
        self->_rightEyeDiameter = self.leftEyeDiameter;
        self->_rightEyeOutlineColor = self.leftEyeOutlineColor;
        self->_rightEyeColor = self.leftEyeColor;
        self->_rightEyePupilColor = self.leftEyePupilColor;
        // user default
        [self createUserDefaults];
        [self loadUserDefaults];
    }
    return self;
}

// methods

- (void)createUserDefaults {
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:self.leftEyeDiameter], @"LeftEyeDiameter",
                              [NSKeyedArchiver archivedDataWithRootObject:self.leftEyeOutlineColor], @"LeftEyeOutlineColor",
                              [NSKeyedArchiver archivedDataWithRootObject:self.leftEyeColor], @"LeftEyeColor",
                              [NSKeyedArchiver archivedDataWithRootObject:self.leftEyePupilColor], @"LeftEyePupilColor",
                              [NSNumber numberWithFloat:self.rightEyeDiameter], @"RightEyeDiameter",
                              [NSKeyedArchiver archivedDataWithRootObject:self.rightEyeOutlineColor], @"RightEyeOutlineColor",
                              [NSKeyedArchiver archivedDataWithRootObject:self.rightEyeColor], @"RightEyeColor",
                              [NSKeyedArchiver archivedDataWithRootObject:self.rightEyePupilColor], @"RightEyePupilColor",
                              @"YES", @"EyeSync",
                              nil];
    
    NSArray *resettableDefaults = [NSArray arrayWithObjects:@"LeftEyeDiameter", @"LeftEyeOutlineColor", @"LeftEyeColor", @"LeftEyePupilColor", @"RightEyeDiameter", @"RightEyeOutlineColor", @"RightEyeColor", @"RightEyePupilColor", @"EyeSync", nil];
    
    NSDictionary *initialValues = [defaults dictionaryWithValuesForKeys:resettableDefaults];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValues];
}

- (void)saveUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:self.leftEyeDiameter
                forKey:@"LeftEyeDiameter"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.leftEyeOutlineColor]
                 forKey:@"LeftEyeOutlineColor"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.leftEyeColor]
                 forKey:@"LeftEyeColor"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.leftEyePupilColor]
                 forKey:@"LeftEyePupilColor"];
    [defaults setFloat:self.rightEyeDiameter
                forKey:@"RightEyeDiameter"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.rightEyeOutlineColor]
                 forKey:@"RightEyeOutlineColor"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.rightEyeColor]
                 forKey:@"RightEyeColor"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.rightEyePupilColor]
                 forKey:@"RightEyePupilColor"];
    [defaults setBool:self.eyeSync
               forKey:@"EyeSync"];
    
    [defaults synchronize];
}

- (void)saveUserDefaultsWithSynchronize {
    [self saveUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.leftEyeDiameter = [defaults floatForKey:@"LeftEyeDiameter"];
    self.leftEyeOutlineColor = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"LeftEyeOutlineColor"]];
    self.leftEyeColor = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"LeftEyeColor"]];
    self.leftEyePupilColor = (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"LeftEyePupilColor"]];
    self.rightEyeDiameter = [defaults floatForKey:@"RightEyeDiameter"];
    self.rightEyeOutlineColor = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"RightEyeOutlineColor"]];
    self.rightEyeColor = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"RightEyeColor"]];
    self.rightEyePupilColor = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"RightEyePupilColor"]];
    self.eyeSync = [defaults boolForKey:@"EyeSync"];
}

- (void)loadUserDefaultsWithSynchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadUserDefaults];
}

- (BOOL)synchronizeUserDefaults {
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetDefaults; {
    [[NSUserDefaultsController sharedUserDefaultsController] revertToInitialValues:nil];
    [self loadUserDefaults];
}

@end
