//
//  Preferences.h
//  Gucky
//
//  Created by Christoph Zirkelbach on 19.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EyeSet;

// The Preferences class holds the app specific settings
// and handles the communication with the user defaults.
@interface Preferences : NSObject

// The Properties for the storable settings.
@property EyeSet *presetDefault, *presetSet1, *presetSet2;
@property EyeSet *eyeSetCurrent, *eyeSetUser;

// Sets the presets.
- (void)setPresets;

// Sets the settings for a key string.
- (void)setPresetforKey:(NSString*)aKey;

// Creates the initial and resettable user defaults.
- (void)createUserDefaults;

// Loads the settings from the user defaults.
- (void)loadUserDefaults;
- (void)loadUserDefaultsWithSynchronize;

// Saves the settings to the user defaults.
- (void)saveUserDefaults;
- (void)saveUserDefaultsWithSynchronize;

// Forces an synchronize of the user defaults.
- (BOOL)synchronizeUserDefaults;

// Resets the settings to the initial user defaults.
- (void)resetDefaults;

@end
