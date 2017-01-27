//
//  AppDelegate.m
//  MilesTheConcierge_ObjC
//
//  Created by James McKee on 26/01/2017.
//  Copyright © 2017 James McKee. All rights reserved.
//
//  Credits and References:
//  https://developer.apple.com/library/ios/samplecode/AirLocate/Listings/ReadMe_txt.html
//  https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf
//  https://devnet.cisco.com
//


#import "AppDelegate.h"
@import UserNotifications; // iOS 10 addition

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) //iOS 10 definition

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2];
    [self registerForRemoteNotifications];
    
    
    
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


- (void)registerForRemoteNotifications {
    // Check for iOS 10
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        // Old iOS <9 method can be added here if necessary
        //[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        NSLog(@"Please check iOS version for notification support");
    }
}


// Called when a notification is delivered to a foreground app - iOS 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

// Called to let your app know which action was selected by the user for a given notification - iOS 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
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
        
        // iOS10 UNNotification Implementation
        UNMutableNotificationContent * notification = [[UNMutableNotificationContent alloc] init];
        if ([self.beaconRegion.major intValue] == 0) {
            
            // title - iOS10 notifications
            notification.title = [NSString localizedUserNotificationStringForKey:@"Miles the Concierge:" arguments:nil];
            
            // use user customised UI notification from NSUserDefaults
            notification.body = [[NSUserDefaults standardUserDefaults] valueForKey:@"NotificationName"];
            notification.sound = [UNNotificationSound defaultSound];
            notification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        }
        
        // define notification trigger (region)
        UNLocationNotificationTrigger *locTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Beacon"
                                                                              content:notification trigger:locTrigger];
        // Schedule local notification
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"NotificationRequest was succeeful!");
            }
        }];
        
    }
}

@end
