//
//  BeaconViewController.m
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

#import "BeaconViewController.h"
#import "AppDelegate.h"

@interface BeaconViewController () 

@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#pragma Customise Status Bar
    //remove status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    // Observe custom notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recieveAlert:) name:@"MilesConcierge" object:nil];
    
    // Setup delegate method
    AppDelegate * delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    // Display current NSUserDefaults
    NSLog(@"Current NSUserDefault Settings");
    NSLog(@"Server Name: %@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] valueForKey:@"ServerName"]);
    NSLog(@"URI Endpoint: %@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] valueForKey:@"URIName"]);
    NSLog(@"UI Notification String: %@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] valueForKey:@"NotificationName"]);
    
    // Start Monitoring for UUID
    [delegate startMonitoringForMajor:0 minor:0];
}


-(void) recieveAlert:(NSNotification *) notification {
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in the storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"StartJabberGuest"])
    {
        // Get reference to the destination view controller
        CJGuestCallViewController *cc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like ...
        cc.serverName = [[NSUserDefaults standardUserDefaults] valueForKey:@"ServerName"];
        cc.toURI = [[NSUserDefaults standardUserDefaults] valueForKey:@"URIName"];
        cc.delegate = self;
    }
}


- (void) callFinishedForCallController:(CJGuestCallViewController *)callController
{
    callController.navigationController.navigationBarHidden = NO;
    [callController.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
