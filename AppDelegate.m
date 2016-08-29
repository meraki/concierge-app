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
//  https://devnet.cisco.com
//


#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2];
    [self registerForRemoteNotification];
    
    // Setup default values for first time launch
    NSMutableDictionary *defaultsDictionary = [@{@"ServerName":@"jabberguestsandbox.cisco.com",
                                                 @"URIName":@"5555",
                                                 @"NotificationName":@"Welcome to our business! Please slide to contact Miles our video concierge."} mutableCopy];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictionary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Clear out any badges (associated with app icon)
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}


- (void)registerForRemoteNotification {
    
    // Register for remote notifications
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    // Check user did register for notifications
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application{
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
    
    // Add region instantiation (note fixed UUID)
    NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-0003-D0F5A71096E0"];
    
    // Create a new region
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:major
                                                                minor:minor
                                                           identifier:@"MilesConcierge"];
    
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
        
        UILocalNotification * notification = [[UILocalNotification alloc] init];
        if ([self.beaconRegion.major intValue] == 0) {
            
            // use user customised UI notification from NSUserDefaults
            notification.alertBody = [[NSUserDefaults standardUserDefaults] valueForKey:@"NotificationName"];
        }
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

@end
