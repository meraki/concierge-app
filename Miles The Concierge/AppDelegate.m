//
//  AppDelegate.m
//  MilesTheConcierge_ObjC
//
//  Created by James McKee on 15/02/2016.
//  Copyright © 2016 James McKee. All rights reserved.
//
//  Credits and References:
//  https://developer.apple.com/library/ios/samplecode/AirLocate/Listings/ReadMe_txt.html
//  https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf
//  https://developer.cisco.com/site/jabber-guestsdk/documents/guest-ios-dev-guide/
//


#import "AppDelegate.h"
#import <JabberGuest/JabberGuest.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

// Implement Jabber Guest ViewController
@implementation AppDelegate {
    CJGuestCallViewController * jabberGuestController;
}


// General Application Management
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2];
    [self registerForRemoteNotification];

    // Add Cisco Jabber Guest frame space
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewController * fvc = [[ViewController alloc] init];
    
    // Create Navigation Controller and Customise
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self.window setRootViewController:navController];
    [navController.navigationBar setHidden:NO];
    navController.navigationBar.topItem.title = @"Welcome To Our Business";
    
    // Set Background to White
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Clear out any Badges on UI
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}


// Register Application for Remote Notifications
// Do not forget plist settings.
// NSLocationAlwaysUsageDescription
// NSLocationWhenInUseUsageDescription
- (void)registerForRemoteNotification {

        [[UIApplication sharedApplication]
         registerUserNotificationSettings:[UIUserNotificationSettings
                                           settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
}


// Check for Notifcation Registration
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}


// Application Management
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [jabberGuestController enterForeground];
}


// Application Management
- (void)applicationWillTerminate:(UIApplication *)application
{
    [jabberGuestController terminate];
}


// Method to start monitoring for Major Beacon ID
-(void)startMonitoringForMajor:(NSInteger)major minor:(NSInteger)minor {
    
    // Check if location manager exists yet. If not create. Ask permission.
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.delegate = self;
    }
    
    // If beacon region exists, stop monitoring
    if (self.beaconRegion) {
        [self.locationManager stopMonitoringForRegion:self.beaconRegion];
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }
    
    // Add region instantiation
    NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-0003-D0F5A71096E0"];
    
    // Create a new region
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                major:major
                                                minor:minor
                                            identifier:@"MikeConcierge"];
    
    // Start ranging beacons straight away
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}


// Stop beacon ranging when app is in the background
-(void) applicationDidEnterBackground:(UIApplication *)application {
    if (self.beaconRegion) {
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }
    [jabberGuestController enterBackground];
}

// Start beacon ranging when app is in foreground
-(void)applicationDidBecomeActive:(UIApplication *)application {
    if (self.beaconRegion) {
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    }
}


// Present local notification when 'in region' conditions are met.
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    // When user enters region, they will be prompted with the message configured below
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        
        // NOTE: Add variable page for notification in next release
        UILocalNotification * notification = [[UILocalNotification alloc] init];
        if ([self.beaconRegion.major intValue] == 0) {
            notification.alertBody = @"Welcome to our business! Please slide to contact Miles our video concierge.";
        }
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

@end
