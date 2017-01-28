//
//  AppDelegate.h
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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h> //iOS 10 - User Notifications Framework

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate,UNUserNotificationCenterDelegate> //iOS 10 - UNUserNotificationCenterDelegate

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLBeaconRegion * beaconRegion;

-(void)startMonitoringForMajor:(NSInteger)major minor:(NSInteger)minor;

@end
