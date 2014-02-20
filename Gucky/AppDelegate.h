//
//  AppDelegate.h
//  Gucky
//
//  Created by Christoph Zirkelbach on 16.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Preferences;
@class EyeFace, EyeSet, Eye;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    // status item
    NSStatusItem *statusItem;
    
    // eyes
    EyeFace *face;
    
    // preferences
    Preferences *pref;
    NSWindowController *preferencesWindowController;
}

// properties

// status menu outlets
@property (weak) IBOutlet NSMenu *statusMenu;

// settings outlets
@property (unsafe_unretained) IBOutlet NSWindow *windowPreferences;
@property (weak) IBOutlet NSTextField *labelBundleName;
@property (weak) IBOutlet NSTextField *labelVersion;
@property (weak) IBOutlet NSTextField *labelCopyright;

@property (weak) IBOutlet NSSlider *sliderLeftEyeSize;
@property (weak) IBOutlet NSColorWell *leftEyeOutlineColor;
@property (weak) IBOutlet NSColorWell *leftEyeColor;
@property (weak) IBOutlet NSColorWell *leftEyePupilColor;

@property (weak) IBOutlet NSSlider *sliderRightEyeSize;
@property (weak) IBOutlet NSColorWell *rightEyeOutlineColor;
@property (weak) IBOutlet NSColorWell *rightEyeColor;
@property (weak) IBOutlet NSColorWell *rightEyePupilColor;
@property (weak) IBOutlet NSButton *buttonSyncOnOff;

@property (weak) IBOutlet NSSegmentedControl *buttonPresets;
@property (weak) IBOutlet NSButton *buttonLaunchAtLogin;

// status menu actions
- (IBAction)actionMenuRefreshPosition:(id)sender;
- (IBAction)actionMenuPreferences:(id)sender;

// setting window actions
- (IBAction)actionChangeEyeSize:(id)sender;
- (IBAction)actionChangeColor:(id)sender;
- (IBAction)buttonSyncOnOff:(id)sender;
- (IBAction)buttonPresetSettings:(id)sender;

// methods

// Detects the needed StatusItem position.
- (void)detectStatusItemPosition;

// Checks and sets if a new StatusItem image is needed.
- (void)myMouseMoved:(NSPoint)point;

// Sets an image for a given EyeSet and button segment.
- (void)setButtonPresetImageWithEyeSet:(EyeSet*)aEyeSet
                            forSegment:(NSInteger)aSegment;

// Forces a StatusImage refresh.
- (void)forceStatusItemImageRefresh;

// Saves temporary user settings.
- (void)saveUserSettings;

// Selects a preset.
- (void)selectSetting:(NSInteger)aSet;

// Syncs the preference settings.
- (void)syncOnOff:(bool)aState;

// Loads the settings to the face instance and the preferences dialog.
- (void)setPreferences;

// Sets the about infos.
- (void)setAboutInfos;

@end
