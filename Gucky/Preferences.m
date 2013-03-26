//
//  Preferences.m
//  Gucky
//
//  Created by Christoph Zirkelbach on 19.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import "Preferences.h"
#import "EyeSet.h"

@implementation Preferences

// init

- (id)init {
    self = [super init];
    if (self != nil) {
        // init presets
        [self setPresets];
        
        // init current and user eye sets
        self.eyeSetCurrent = [self.presetDefault copy];
        self.eyeSetUser = [self.presetDefault copy];
        
        // init user default
        [self createUserDefaults];
        [self loadUserDefaults];
    }
    return self;
}

// methods

- (void)setPresets {
    // defaults
    self.presetDefault = [[EyeSet alloc] init];
    
    // preset 1, 2
    self.presetSet1 = [[EyeSet alloc] initWithLeftEyeDiameter:19 rightEyeDiameter:35];
    self.presetSet2 = [[EyeSet alloc] initWithLeftEyeDiameter:35];
}

- (void)setPresetforKey:(NSString*)aKey {
    if ([aKey isEqualTo:@"Default"])
        self.eyeSetCurrent = [self.presetDefault copy];
    else if ([aKey isEqualTo:@"Preset 1"])
        self.eyeSetCurrent = [self.presetSet1 copy];
    else if ([aKey isEqualTo:@"Preset 2"])
        self.eyeSetCurrent = [self.presetSet2 copy];
    else if ([aKey isEqualTo:@"User"])
        self.eyeSetCurrent = [self.eyeSetUser copy];
}

- (void)createUserDefaults {
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithFloat:[self.presetDefault leftEyeDiameter]], @"LeftEyeDiameter",
      [NSKeyedArchiver archivedDataWithRootObject:[self.presetDefault leftEyeOutlineColor]], @"LeftEyeOutlineColor",
      [NSKeyedArchiver archivedDataWithRootObject:[self.presetDefault leftEyeEyeballColor]], @"LeftEyeColor",
      [NSKeyedArchiver archivedDataWithRootObject:[self.presetDefault leftEyePupilColor]], @"LeftEyePupilColor",
      [NSNumber numberWithFloat:[self.presetDefault rightEyeDiameter]], @"RightEyeDiameter",
      [NSKeyedArchiver archivedDataWithRootObject:[self.presetDefault rightEyeOutlineColor]], @"RightEyeOutlineColor",
      [NSKeyedArchiver archivedDataWithRootObject:[self.presetDefault rightEyeEyeballColor]], @"RightEyeColor",
      [NSKeyedArchiver archivedDataWithRootObject:[self.presetDefault rightEyePupilColor]], @"RightEyePupilColor",
      [NSNumber numberWithBool:[self.presetDefault isEyeSync]], @"EyeSync",
      nil];
    
    NSArray *resettableDefaults = [NSArray arrayWithObjects:@"LeftEyeDiameter", @"LeftEyeOutlineColor", @"LeftEyeColor", @"LeftEyePupilColor", @"RightEyeDiameter", @"RightEyeOutlineColor", @"RightEyeColor", @"RightEyePupilColor", @"EyeSync", nil];
    
    NSDictionary *initialValues = [defaults dictionaryWithValuesForKeys:resettableDefaults];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValues];
}

- (void)saveUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:[self.eyeSetCurrent leftEyeDiameter]
                forKey:@"LeftEyeDiameter"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self.eyeSetCurrent leftEyeOutlineColor]]
                 forKey:@"LeftEyeOutlineColor"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self.eyeSetCurrent leftEyeEyeballColor]]
                 forKey:@"LeftEyeColor"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self.eyeSetCurrent leftEyePupilColor]]
                 forKey:@"LeftEyePupilColor"];
    [defaults setFloat:[self.eyeSetCurrent rightEyeDiameter]
                forKey:@"RightEyeDiameter"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self.eyeSetCurrent rightEyeOutlineColor]]
                 forKey:@"RightEyeOutlineColor"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self.eyeSetCurrent rightEyeEyeballColor]]
                 forKey:@"RightEyeColor"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self.eyeSetCurrent rightEyePupilColor]]
                 forKey:@"RightEyePupilColor"];
    [defaults setBool:[self.eyeSetCurrent isEyeSync]
               forKey:@"EyeSync"];
    
    [defaults synchronize];
}

- (void)saveUserDefaultsWithSynchronize {
    [self saveUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.eyeSetCurrent setLeftEyeDiameter:[defaults floatForKey:@"LeftEyeDiameter"]];
    [self.eyeSetCurrent setLeftEyeOutlineColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"LeftEyeOutlineColor"]]];
    [self.eyeSetCurrent setLeftEyeEyeballColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"LeftEyeColor"]]];
    [self.eyeSetCurrent setLeftEyePupilColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"LeftEyePupilColor"]]];
    [self.eyeSetCurrent setRightEyeDiameter:[defaults floatForKey:@"RightEyeDiameter"]];
    [self.eyeSetCurrent setRightEyeOutlineColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"RightEyeOutlineColor"]]];
    [self.eyeSetCurrent setRightEyeEyeballColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"RightEyeColor"]]];
    [self.eyeSetCurrent setRightEyePupilColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"RightEyePupilColor"]]];
    [self.eyeSetCurrent setEyeSync:[defaults boolForKey:@"EyeSync"]];
    
    //
    self.eyeSetUser = [self.eyeSetCurrent copy];
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
