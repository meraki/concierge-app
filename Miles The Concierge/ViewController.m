//
//  ViewController.m
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


#import "ViewController.h"
#import "AppDelegate.h"
#import <JabberGuest/JabberGuest.h>

@interface ViewController () <CJGuestCallViewControllerDelegate> {
    CJGuestCallViewController * jabberG;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Observe custom notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recieveAlert:) name:@"MilesAvail" object:nil];
    
    // Setup delegate method
    AppDelegate * delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    // Start Monitoring for UUID
    [delegate startMonitoringForMajor:0 minor:0];
}
     

- (void) recieveAlert:(NSNotification *) notification
     {
         CLBeacon * beacon = notification.object;
         beacon = beacon.init;
     }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)callFinishedForCallController:(CJGuestCallViewController *)callController
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)launchCJCall:(UIButton *)sender {
    NSLog(@"Call has been launched.");
    [self.navigationController.navigationBar setHidden:NO];
    
    jabberG = [[CJGuestCallViewController alloc] init];
    
    if (jabberG) {
        
        // Configure Jabber Guest server/URI        
        [jabberG setServerName:@"jabberguestsandbox.cisco.com"];
        [jabberG setToURI:@"5555"];
        
        jabberG.delegate = self;
        
        [self.navigationController pushViewController:jabberG animated:YES];
    }
}

@end
