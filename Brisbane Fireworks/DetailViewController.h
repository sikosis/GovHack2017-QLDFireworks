//
//  DetailViewController.h
//  Brisbane Fireworks
//
//  Created by Phil Greenway on 28/7/17.
//  Copyright © 2017 Code Army. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>


@interface DetailViewController : ViewController <MKMapViewDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate> {
    IBOutlet MKMapView *mapView;

    NSString *_fwdate;
    NSString *_fwaddress;
    NSString *_fwsuburb;
    NSString *_fwpcode;
    NSString *fulladdress;
}

@end
