//
//  ViewController.h
//  Brisbane Fireworks
//
//  Created by Phil Greenway on 28/7/17.
//  Copyright © 2017 Code Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"


@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *fwTable;
    IBOutlet UIImageView *splashScreen;
    
    IBOutlet UINavigationItem *navItem;
    
    NSMutableArray *fwdate;
    NSMutableArray *fwaddress;
    NSMutableArray *fwsuburb;
    NSMutableArray *fwpcode;
    
    NSMutableArray *colours;
    int colourCounter;
    
    LoadingView *_loadingView;
    
    UIImageView *oops; // TODO: remove or add
    
}

-(IBAction)btnRefresh:(id)sender;


@end

