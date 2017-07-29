//
//  DetailViewController.m
//  Brisbane Fireworks
//
//  Created by Phil Greenway on 28/7/17.
//  Copyright © 2017 Code Army. All rights reserved.
//

#import "DetailViewController.h"
#import "CommonFunctions.h"
#import <Social/Social.h>
#import "TOActionSheet.h"
#import <CoreLocation/CoreLocation.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _fwdate = [userDefaults stringForKey:@"fwdate"];
    _fwaddress = [userDefaults stringForKey:@"fwaddress"];
    _fwsuburb = [userDefaults stringForKey:@"fwsuburb"];
    _fwpcode = [userDefaults stringForKey:@"fwpcode"];
    fulladdress = [userDefaults stringForKey:@"fulladdress"];
    
    
    if ([_fwdate length] == 0) {
        // damn nsuserdefaults isn't working ... backup super hack to the rescue
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"nsuserdefaults.txt"];
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        
        // split via |
        NSArray *items = [str componentsSeparatedByString:@"|"];
        _fwdate = [items objectAtIndex:0];
        _fwaddress = [items objectAtIndex:1];
        _fwsuburb = [items objectAtIndex:2];
        _fwpcode = [items objectAtIndex:3];
        fulladdress = [items objectAtIndex:4];
    }
    
    
    self.title = _fwsuburb;
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(home:)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleDone target:self action:@selector(btnShare:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
//    navItem.rightBarButtonItem = rightButton;

    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    // TODO: search fulladdress

    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord = [self getLocationFromAddressString:fulladdress];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = _fwaddress;
    annotationPoint.subtitle = [NSString stringWithFormat:@"%@ %@",_fwsuburb,_fwpcode];
    [mapView addAnnotation:annotationPoint];

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.125;
    span.longitudeDelta = 0.125;
    region.span = span;
    region.center = annotationCoord;
    [mapView regionThatFits:region];
    
    [mapView setRegion:region animated:YES];
}


#pragma mark - Map Stuff

-(void)mapView:(MKMapView *)_mapView didUpdateUserLocation: (MKUserLocation *)userLocation {
    mapView.centerCoordinate = userLocation.location.coordinate;
}


-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?sensor=true&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    //NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    //NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}


#pragma mark -



-(void)home:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons

-(IBAction)btnShare:(id)sender {
    TOActionSheet *actionSheet = [[TOActionSheet alloc] init];
    
    actionSheet.title = @"Share via";
    actionSheet.style = TOActionSheetStyleLight;
    
    [actionSheet addButtonWithTitle:@"Add to Calendar" tappedBlock:^{
        [self addToCalendar];
        
    }];
    [actionSheet addButtonWithTitle:@"Email" tappedBlock:^{
        [self sendEmail];
        
    }];
    [actionSheet addButtonWithTitle:@"Facebook" tappedBlock:^{
        [self sendFacebook];
        
    }];
    [actionSheet addButtonWithTitle:@"Twitter" tappedBlock:^{
        [self sendTwitter];
        
    }];
    
    UIButton *button = (UIButton *)sender;
    [actionSheet showFromView:button inView:self.view];
}


#pragma mark - Send Commands

-(void)addToCalendar {
    NSLog(@"Add to Calendar");
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                event.title = [NSString stringWithFormat:@"🎇 Fireworks - %@",_fwsuburb];
//                event.URL = [NSURL URLWithString:_turl];

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"cccc d LLLL y k:m"];
                NSDate *calendarStartDate = [dateFormatter dateFromString:_fwdate];
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
                
                event.startDate = calendarStartDate;
                event.endDate   = [[NSDate alloc] initWithTimeInterval:3600 sinceDate:event.startDate]; // 60 minute ???
                NSMutableArray *myAlarmArray =[[NSMutableArray alloc] init];
                EKAlarm *alarm1;
                alarm1 = [EKAlarm alarmWithRelativeOffset:-300]; // 5 minutes before
                [myAlarmArray addObject:alarm1];
                event.alarms = myAlarmArray;

                // default calendar ... might need to fix this for iPhone use
                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                NSError *err = nil;
                [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                
                NSLog(@"%@",[err localizedDescription]);
                // [self performCalendarActivity:eventStore];
            } else {
                // code here for when the user does NOT allow your app to access the calendar
            }
        }];
    } else {
        // code here for iOS < 6.0
        // n/a -- iOS 9-10 only
    }
    
    
}

-(void)sendEmail {
    NSString *emailTitle = [NSString stringWithFormat:@"Fireworks - %@",_fwsuburb];
    NSString *messageBody = [NSString stringWithFormat:@"There is a fireworks display at %@ on %@.",fulladdress,_fwdate];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}


-(int)randomNumberFrom:(int)minValue to:(int)maxValue {
    double probability = rand() / 2147483648.0;
    double range = maxValue - minValue + 1;
    return (int)(range * probability + minValue);
}


-(void)sendFacebook {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *fvc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        // can't have initial text anymore
        //[fvc setInitialText:[NSString stringWithFormat:@"Fireworks - %@ on %@. 🎇",_fwsuburb,_fwdate]];
        
        // random image then
        int maxImages = [colours count] - 1;
        int randomImage = [self randomNumberFrom:0 to:maxImages];
        [fvc addImage:[UIImage imageNamed:[colours objectAtIndex:randomImage]]];

        [self presentViewController:fvc animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Facebook Account"
                                                            message:@"Please setup your Facebook account in iOS Settings prior to using."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}




-(void)sendTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"#Fireworks Display in %@ on %@. 🎇",_fwsuburb,_fwdate]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Twitter Account"
                                                            message:@"Please setup your Twitter account in iOS Settings prior to using."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma mark - Mail Delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
