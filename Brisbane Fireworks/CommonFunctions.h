//
//  CommonFunctions.h
//
//  Created by Phil Greenway on 23/10/12.
//  Copyright (c) 2012-2017 Code Army. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFunctions : NSObject {
}




+(CommonFunctions *)shared;



// Activity
-(void)showActivity;
-(void)hideActivity;

// Alerts
-(void)noInternetAlert;
-(void)customAlert:(NSString *)title setMessage:(NSString *)msg;
-(void)customAlertTwoButtons:(NSString *)title setMessage:(NSString *)msg setSecondButton:(NSString *)btn;

-(int)randomNumberFrom:(int)minValue to:(int)maxValue;

@end
