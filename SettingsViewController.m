//
//  SettingsViewController.m
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

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *serverName;
@property (weak, nonatomic) IBOutlet UITextField *toURI;
@property (weak, nonatomic) IBOutlet UITextField *notificationText;

@end

@implementation SettingsViewController

- (IBAction)saveData:(id)sender
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.serverName.text forKey:@"ServerName"];
    [userDefaults setObject:self.toURI.text forKey:@"URIName"];
    [userDefaults setObject:self.notificationText.text forKey:@"NotificationName"];
    
    [userDefaults synchronize];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serverName.delegate = self;
    self.toURI.delegate = self;
    self.notificationText.delegate = self;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    self.serverName.text = [userDefaults objectForKey:@"ServerName"];
    self.toURI.text = [userDefaults objectForKey:@"URIName"];
    self.notificationText.text = [userDefaults objectForKey:@"NotificationName"];
}


- (void) didRecieveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
