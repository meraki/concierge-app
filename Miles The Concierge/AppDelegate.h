//
//  AppDelegate.h
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


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// Setup delegate requirements
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLBeaconRegion * beaconRegion;

-(void)startMonitoringForMajor:(NSInteger)major minor:(NSInteger)minor;

@end




