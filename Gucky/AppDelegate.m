//
//  AppDelegate.m
//  Gucky
//
//  Created by Christoph Zirkelbach on 16.03.13.
//  Copyright (c) 2013 Christoph Zirkelbach. All rights reserved.
//

#import "AppDelegate.h"
#import "Preferences.h"
#import "EyeFace.h"
#import "EyeSet.h"
#import "Eye.h"
#import "LaunchAtLoginController.h"

@implementation AppDelegate

- (void) awakeFromNib {
    // delegate
    [self->_windowPreferences setDelegate:(id)self];
    
    // init preferences
    pref = [[Preferences alloc] init];
    
    // init NSStatusBar item
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[statusItem setMenu:self.statusMenu];
    [statusItem setImage:nil]; // Note: sets y to bottom left
	[statusItem setHighlightMode:YES];
    
    // init face data
    face = [[EyeFace alloc] init];
    
    // set settings to the face and preferences window
    [self setPreferences];
    [self setButtonPresetImageWithEyeSet:[pref eyeSetUser] forSegment:3];
    
    // preferences: set about infos
    [self setAboutInfos];
    
    // set Default, 1, 2 button images
    [self setButtonPresetImageWithEyeSet:[pref presetDefault] forSegment:0];
    [self setButtonPresetImageWithEyeSet:[pref presetSet1] forSegment:1];
    [self setButtonPresetImageWithEyeSet:[pref presetSet2] forSegment:2];
    
    // register mouse move event handler
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *mouseEvent) {
        [self myMouseMoved:[NSEvent mouseLocation]];
    }];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)windowWillClose:(NSNotification *)notification {
    // close settings window
    if ([[notification object] isEqual:self.windowPreferences]) {
        // save settings
        [[pref eyeSetCurrent] setLeftEyeDiameter:[self.sliderLeftEyeSize integerValue]];
        [[pref eyeSetCurrent] setLeftEyeOutlineColor:[self.leftEyeOutlineColor color]];
        [[pref eyeSetCurrent] setLeftEyeEyeballColor:[self.leftEyeColor color]];
        [[pref eyeSetCurrent] setLeftEyePupilColor:[self.leftEyePupilColor color]];
        [[pref eyeSetCurrent] setRightEyeDiameter:[self.sliderRightEyeSize integerValue]];
        [[pref eyeSetCurrent] setRightEyeOutlineColor:[self.rightEyeOutlineColor color]];
        [[pref eyeSetCurrent] setRightEyeEyeballColor:[self.rightEyeColor color]];
        [[pref eyeSetCurrent] setRightEyePupilColor:[self.rightEyePupilColor color]];
        [[pref eyeSetCurrent] setEyeSync:[self.buttonSyncOnOff state]];
        [pref saveUserDefaults];
        // set new position
        [self detectStatusItemPosition];
        // refresh statusbar image
        [self forceStatusItemImageRefresh];
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [pref synchronizeUserDefaults];
}

// status menu actions

- (IBAction)actionMenuRefreshPosition:(id)sender {
    [self detectStatusItemPosition];
    [statusItem setImage:[face pupilImage]];
}

- (IBAction)actionMenuPreferences:(id)sender {
    if( preferencesWindowController == nil )
        preferencesWindowController = [[NSWindowController alloc] initWithWindow:self.windowPreferences];
    [preferencesWindowController showWindow:sender];
    // force preference window to front
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    
    if([launchController willLaunchAtLogin:launchController.appURL]) {
        [self.buttonLaunchAtLogin setState:NSOnState];
    } else {
        [self.buttonLaunchAtLogin setState:NSOffState];
    }
}

// setting window actions

- (IBAction)actionChangeEyeSize:(id)sender {
    if ([sender isEqual:self.sliderLeftEyeSize]) {
        [[face leftEye] setDiameter:[sender integerValue]];
        if ([self.buttonSyncOnOff state]) {
            [[face rightEye] setDiameter:[sender integerValue]];
            [self.sliderRightEyeSize setIntegerValue:[self.sliderLeftEyeSize integerValue]];
        }
    } else if ([sender isEqual:self.sliderRightEyeSize])
        [[face rightEye] setDiameter:[sender integerValue]];
    
    [self saveUserSettings];
    [self forceStatusItemImageRefresh];
    [self setButtonPresetImageWithEyeSet:[pref eyeSetUser] forSegment:3];
    [sender display]; // display error fix
}

- (IBAction)actionChangeColor:(id)sender {
    if ([sender isEqual:self.leftEyeOutlineColor]) {
        [[face leftEye] setOutlineColor:[sender color]];
        if ([self.buttonSyncOnOff state]) {
            [[face rightEye] setOutlineColor:[sender color]];
            [self.rightEyeOutlineColor setColor:[self.leftEyeOutlineColor color]];
        }
    } else if ([sender isEqual:self.leftEyeColor]) {
        [[face leftEye] setEyeballColor:[sender color]];
        if ([self.buttonSyncOnOff state]) {
            [[face rightEye] setEyeballColor:[sender color]];
            [self.rightEyeColor setColor:[self.leftEyeColor color]];
        }
    } else if ([sender isEqual:self.leftEyePupilColor]) {
        [[face leftEye] setPupilColor:[sender color]];
        if ([self.buttonSyncOnOff state]) {
            [[face rightEye] setPupilColor:[sender color]];
            [self.rightEyePupilColor setColor:[self.leftEyePupilColor color]];
        }
    } else if ([sender isEqual:self.rightEyeOutlineColor])
        [[face rightEye] setOutlineColor:[sender color]];
    else if ([sender isEqual:self.rightEyeColor])
        [[face rightEye] setEyeballColor:[sender color]];
    else if ([sender isEqual:self.rightEyePupilColor])
        [[face rightEye] setPupilColor:[sender color]];
    
    [self saveUserSettings];
    [self forceStatusItemImageRefresh];
    [self setButtonPresetImageWithEyeSet:[pref eyeSetUser] forSegment:3];
    [sender display]; // display error fix
}

- (IBAction)buttonSyncOnOff:(id)sender {
    [self syncOnOff:[sender state]];
    [self saveUserSettings];
    [self setButtonPresetImageWithEyeSet:[pref eyeSetUser] forSegment:3];
}

- (IBAction)buttonPresetSettings:(id)sender {
    [self selectSetting:[sender selectedSegment]];
}

-(IBAction)launchAtLogin:(id)sender {
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    [launchController setLaunchAtLogin:([self.buttonLaunchAtLogin state]==NSOnState)];
}
// methods

- (void)detectStatusItemPosition {
    [face calcCenterForAllEyes];

    // source
    // - http://the-useful.blogspot.de/2012/01/getting-nsstatusitem-co-ordinates.html
    NSView *statusBarView = [[NSView alloc]initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, [face size].width, 0))];
    [statusItem setView:statusBarView];
    statusBarView = nil;
    NSRect rect = [[[statusItem view] window] frame];
    [statusItem setView:NULL];
    [statusItem setHighlightMode:YES];

    //NSLog(@"--> x: %f y: %f w: %f h: %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);

    [face setOrigin:NSMakePoint(rect.origin.x - 3, rect.origin.y)]; // -3 ?
}

- (void)myMouseMoved:(NSPoint)point {
    if ([face isNewImageForTarget:point])
        [statusItem setImage:[face pupilImage]];
}

- (void)setButtonPresetImageWithEyeSet:(EyeSet*)aEyeSet forSegment:(NSInteger)aSegment {
    EyeFace *tmpFace = [[EyeFace alloc] initWithEyeSet:aEyeSet];
    [tmpFace forceRefresh:NSMakePoint(-200, -400)];
    [[self buttonPresets] setLabel:nil forSegment:aSegment];
    [[self buttonPresets] setImageScaling:NSImageScaleNone forSegment:aSegment];
    
    NSImage *temp = [[tmpFace pupilImage] copy];
    CGFloat height = [[self buttonPresets] frame].size.height - 4.0f;
    [temp setSize:NSMakeSize([temp size].width * height / [temp size].height, height)];
    [[self buttonPresets] setImage:temp forSegment:aSegment];
}

- (void)forceStatusItemImageRefresh {
    [face forceRefresh:[NSEvent mouseLocation]];
    [statusItem setImage:[face pupilImage]];
}

- (void)saveUserSettings {
    [[pref eyeSetUser] setLeftEyeDiameter:[self.sliderLeftEyeSize integerValue]];
    [[pref eyeSetUser] setLeftEyeOutlineColor:[self.leftEyeOutlineColor color]];
    [[pref eyeSetUser] setLeftEyeEyeballColor:[self.leftEyeColor color]];
    [[pref eyeSetUser] setLeftEyePupilColor:[self.leftEyePupilColor color]];
    [[pref eyeSetUser] setRightEyeDiameter:[self.sliderRightEyeSize integerValue]];
    [[pref eyeSetUser] setRightEyeOutlineColor:[self.rightEyeOutlineColor color]];
    [[pref eyeSetUser] setRightEyeEyeballColor:[self.rightEyeColor color]];
    [[pref eyeSetUser] setRightEyePupilColor:[self.rightEyePupilColor color]];
    [[pref eyeSetUser] setEyeSync:[self.buttonSyncOnOff state]];
}

- (void)selectSetting:(NSInteger)aSet {
    // switch preset
    switch (aSet) {
        case 0: // oo - default
            [pref setPresetforKey:@"Default"];
            break;
        case 1: // oO
            [pref setPresetforKey:@"Preset 1"];
            break;
        case 2: // OO
            [pref setPresetforKey:@"Preset 2"];
            break;
        case 3: // user
            [pref setPresetforKey:@"User"];
            break;
    }
    [self setPreferences];
}

- (void)syncOnOff:(bool)aState {
    if (aState) {
        [self.buttonSyncOnOff setState:1];
        [self.buttonSyncOnOff setImage:[NSImage imageNamed:@"NSLockLockedTemplate"]];
        // disable settings right eye
        [self.sliderRightEyeSize setEnabled:false];
        [self.rightEyeOutlineColor setEnabled:false];
        [self.rightEyeColor setEnabled:false];
        [self.rightEyePupilColor setEnabled:false];
        // sync eyes
        [face syncEyes];
        // sync settings
        [self.sliderRightEyeSize setIntegerValue:[self.sliderLeftEyeSize integerValue]];
        [self.rightEyeOutlineColor setColor:[self.leftEyeOutlineColor color]];
        [self.rightEyeColor setColor:[self.leftEyeColor color]];
        [self.rightEyePupilColor setColor:[self.leftEyePupilColor color]];
        // refresh
        [self forceStatusItemImageRefresh];
    } else {
        [self.buttonSyncOnOff setState:0];
        [self.buttonSyncOnOff setImage:[NSImage imageNamed:@"NSLockUnlockedTemplate"]];
        // enable settings right eye
        [self.sliderRightEyeSize setEnabled:true];
        [self.rightEyeOutlineColor setEnabled:true];
        [self.rightEyeColor setEnabled:true];
        [self.rightEyePupilColor setEnabled:true];
    }
}

- (void)setPreferences {
    // set the face
    [face setEyesWithEyeSet:[pref eyeSetCurrent]];
    
    // set the preferences window
    // left eye
    [self.sliderLeftEyeSize setFloatValue:[[pref eyeSetCurrent] leftEyeDiameter]];
    [self.leftEyeOutlineColor setColor:[[pref eyeSetCurrent] leftEyeOutlineColor]];
    [self.leftEyeColor setColor:[[pref eyeSetCurrent] leftEyeEyeballColor]];
    [self.leftEyePupilColor setColor:[[pref eyeSetCurrent] leftEyePupilColor]];
    // right eye
    [self.sliderRightEyeSize setFloatValue:[[pref eyeSetCurrent] rightEyeDiameter]];
    [self.rightEyeOutlineColor setColor:[[pref eyeSetCurrent] rightEyeOutlineColor]];
    [self.rightEyeColor setColor:[[pref eyeSetCurrent] rightEyeEyeballColor]];
    [self.rightEyePupilColor setColor:[[pref eyeSetCurrent] rightEyePupilColor]];
    // extra
    [self.buttonSyncOnOff setState:[[pref eyeSetCurrent] isEyeSync]];
    [self syncOnOff:[self.buttonSyncOnOff state]];
    
    // get status item position
    [self detectStatusItemPosition];
    
    // set statusbar image
    [self forceStatusItemImageRefresh];
}

- (void)setAboutInfos {
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    [self.labelBundleName setStringValue:[appInfo objectForKey:@"CFBundleName"]];
    [self.labelVersion setStringValue:[NSString stringWithFormat:@"Version %@",
                                       [appInfo objectForKey:@"CFBundleShortVersionString"]]];
    [self.labelCopyright setStringValue:[appInfo objectForKey:@"NSHumanReadableCopyright"]];
}

@end
