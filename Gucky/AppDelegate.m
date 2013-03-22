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
#import "Eye.h"

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
    
    // preferences: set about infos
    [self setAboutInfos];

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
        [pref setLeftEyeDiameter:[self.sliderLeftEyeSize integerValue]];
        [pref setLeftEyeOutlineColor:[self.leftEyeOutlineColor color]];
        [pref setLeftEyeColor:[self.leftEyeColor color]];
        [pref setLeftEyePupilColor:[self.leftEyePupilColor color]];
        [pref setRightEyeDiameter:[self.sliderRightEyeSize integerValue]];
        [pref setRightEyeOutlineColor:[self.rightEyeOutlineColor color]];
        [pref setRightEyeColor:[self.rightEyeColor color]];
        [pref setRightEyePupilColor:[self.rightEyePupilColor color]];
        [pref setEyeSync:[self.buttonSyncOnOff state]];
        [pref saveUserDefaults];
        // set new position and refresh statusbar image
        [self detectStatusItemPosition];
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
    
    [self forceStatusItemImageRefresh];
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
    
    [self forceStatusItemImageRefresh];
    [sender display]; // display error fix
}

- (IBAction)buttonResetSettings:(id)sender {
    [pref resetDefaults];
    
    [self setPreferences];
}

- (IBAction)buttonSyncOnOff:(id)sender {
    [self syncOnOff:[sender state]];
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

- (void)forceStatusItemImageRefresh {
    [face forceRefresh:[NSEvent mouseLocation]];
    [statusItem setImage:[face pupilImage]];
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
    // left eye
    [[face leftEye] setDiameter:[pref leftEyeDiameter]];
    [[face leftEye] setOutlineColor:[pref leftEyeOutlineColor]];
    [[face leftEye] setEyeballColor:[pref leftEyeColor]];
    [[face leftEye] setPupilColor:[pref leftEyePupilColor]];
    // right eye
    [[face rightEye] setDiameter:[pref rightEyeDiameter]];
    [[face rightEye] setOutlineColor:[pref rightEyeOutlineColor]];
    [[face rightEye] setEyeballColor:[pref rightEyeColor]];
    [[face rightEye] setPupilColor:[pref rightEyePupilColor]];
    
    // set the preferences window
    // left eye
    [self.sliderLeftEyeSize setFloatValue:[pref leftEyeDiameter]];
    [self.leftEyeOutlineColor setColor:[pref leftEyeOutlineColor]];
    [self.leftEyeColor setColor:[pref leftEyeColor]];
    [self.leftEyePupilColor setColor:[pref leftEyePupilColor]];
    // right eye
    [self.sliderRightEyeSize setFloatValue:[pref rightEyeDiameter]];
    [self.rightEyeOutlineColor setColor:[pref rightEyeOutlineColor]];
    [self.rightEyeColor setColor:[pref rightEyeColor]];
    [self.rightEyePupilColor setColor:[pref rightEyePupilColor]];
    // extra
    [self.buttonSyncOnOff setState:[pref isEyeSync]];
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
