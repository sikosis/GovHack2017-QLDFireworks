//
//  CommonFunctions.m
//
//  Created by Phil Greenway on 23/10/12.
//  Copyright (c) 2012-2017 Code Army. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions


+(CommonFunctions *)shared {
    static CommonFunctions *instance;
    if (!instance) {
        instance = [[CommonFunctions alloc] init];
    }
    return instance;
}


#pragma mark - Activity

-(void)showActivity {
    // UIActivity in the Status Bar
//    UIApplication* app = [UIApplication sharedApplication];
//    app.networkActivityIndicatorVisible = YES;
}


-(void)hideActivity {
    // Turn Off the UIActivity in the Status Bar
//    UIApplication* app = [UIApplication sharedApplication];
//    app.networkActivityIndicatorVisible = NO;
}


#pragma mark - Alert

-(void)noInternetAlert {
//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No/Slow Internet Connection"
//														message:@"This application requires access to the Internet to view News, Schedule and other online facilities."
//													   delegate:self
//											  cancelButtonTitle:@"OK"
//											  otherButtonTitles:nil];
//	[alertView show];
}


-(void)customAlert:(NSString *)title setMessage:(NSString *)msg {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                        message:msg
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
}

-(void)customAlertTwoButtons:(NSString *)title setMessage:(NSString *)msg setSecondButton:(NSString *)btn {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                        message:msg
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:btn, nil];
//    [alertView show];
}

#pragma mark -

-(int)randomNumberFrom:(int)minValue to:(int)maxValue {
    double probability = rand() / 2147483648.0;
    double range = maxValue - minValue + 1;
    return (int)(range * probability + minValue);
}





@end
