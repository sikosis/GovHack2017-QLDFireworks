//
//  ViewController.m
//  Brisbane Fireworks
//
//  Created by Phil Greenway on 28/7/17.
//  Copyright © 2017 Code Army. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "CommonFunctions.h"
#import "FireworksCell.h"
#import "URLConnect.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    // TODO: not actually using this as it doesn't work ...
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:@"fwdate"];
    [userDefaults setObject:@"" forKey:@"fwaddress"];
    [userDefaults setObject:@"" forKey:@"fwsuburb"];
    [userDefaults setObject:@"" forKey:@"fwpcode"];
    [userDefaults setObject:@"" forKey:@"fulladdress"];
    
    [self showLoadingView];
    fwTable.alpha = 0.0;

    colourCounter = 0;
    colours = [[NSMutableArray alloc] initWithCapacity:0];
    [colours addObject:@"yellow.png"];
    [colours addObject:@"blue.png"];
    [colours addObject:@"red.png"];
    [colours addObject:@"orange.png"];
    [colours addObject:@"green.png"];
    [colours addObject:@"purple.png"];

    fwdate = [[NSMutableArray alloc] initWithCapacity:0];
    fwaddress = [[NSMutableArray alloc] initWithCapacity:0];
    fwsuburb = [[NSMutableArray alloc] initWithCapacity:0];
    fwpcode = [[NSMutableArray alloc] initWithCapacity:0];
    
    //[fwdate addObject:@"XX/XX/XXXX"];
    //[fwaddress addObject:@"TEST ST TESTVILLE XXXX"];
    
    [self grabFireworks];
}




-(void)grabFireworks {
    // csv - https://data.qld.gov.au/dataset/ab5e6b38-2455-40c2-bb10-50f923e82654/resource/346d58fc-b7c1-4c38-bf4d-c9d5fb43ce7b/download/25-07-2017-fireworks-display-notification-list.csv
    
    // json - https://data.qld.gov.au/api/action/datastore_search?resource_id=346d58fc-b7c1-4c38-bf4d-c9d5fb43ce7b
    
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://data.qld.gov.au/dataset/ab5e6b38-2455-40c2-bb10-50f923e82654/resource/346d58fc-b7c1-4c38-bf4d-c9d5fb43ce7b/download/25-07-2017-fireworks-display-notification-list.csv"]];

    // Sample Data
//    Display Date,Times(s),Suburb,PCode,Display Address,Event Type,Display Type
//    "Tuesday, 25 July 2017",14:15,BEERWAH,4519,,PRIVATE,Outdoor Displays
//    "Thursday, 27 July 2017",18:00,MOOROOKA,4105,,PRIVATE,Close Proximity
//    "Tuesday, 25 July 2017",20:00,TWIN WATERS,4564,,PRIVATE,Outdoor Displays
//    "Thursday, 27 July 2017",20:30,FORTITUDE VALLEY,4006,,PRIVATE,Close Proximity
//    "Thursday, 27 July 2017",23:00,PORMPURRAW,4871,Wirran St,PUBLIC,Outdoor Displays
    
    URLConnect *connection = [[URLConnect alloc]initWithRequest:urlRequest];
    
    [connection setCompletionBlock:^(id obj, NSError *err) {
        if (!err) {
            NSString *block = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
            NSArray *lines = [block componentsSeparatedByString:@"\n"];
            NSString *oneLine;
            NSArray *fields;
            NSString *insertString;
            long total = [lines count] - 1;
            // skip first line
            for (int z=1;z<total;z++) {
                oneLine = [lines objectAtIndex:z];
                fields = [oneLine componentsSeparatedByString:@","];
                
                if ([[fields objectAtIndex:6] isEqualToString:@"PUBLIC"]) {
                   // NSLog(@"%@",[fields objectAtIndex:2]);
                    insertString = [NSString stringWithFormat:@"%@%@ %@",[fields objectAtIndex:0],[fields objectAtIndex:1],[fields objectAtIndex:2]];
                    
                    insertString = [insertString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    
                    [fwdate addObject:insertString];
                    [fwsuburb addObject:[fields objectAtIndex:3]];
                    [fwpcode addObject:[fields objectAtIndex:4]];
                    [fwaddress addObject:[fields objectAtIndex:5]];
                    
                }
                //NSLog(@"%@",insertString);
            }
            
            [self reloadItems];
            
            [self hideLoadingView];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            fwTable.alpha = 1.0;
            [UIView commitAnimations];
            
        } else {
            NSLog(@"Something went wrong :(");
            
            NSLog(@"%@",err);
            
            _loadingView.alpha = 0.0;
            [_loadingView setHidden:YES];
            
            // TODO: make this better than it is
            [[CommonFunctions shared] noInternetAlert];
            
        }
        
    }];
    
    [connection start];
    
}


#pragma mark - Loading View Helpers


-(void)showLoadingView {
    // Show Loading View
    if (!_loadingView) {
        _loadingView = (LoadingView *)[[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
        CGRect frame = self.view.frame;
        CGRect loadFrame = CGRectMake((frame.size.width / 2) - 70.0, (frame.size.height / 2) - 60.0, 140.0, 120.0);
        _loadingView.frame = loadFrame;
        _loadingView.title.text = @"Loading";
        [self.view addSubview:_loadingView];
    } else {
        _loadingView.alpha = 1.0;
    }
    [_loadingView setHidden:NO];
}



-(void)hideLoadingView {
    // Fade LoadingView
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    _loadingView.alpha = 0.0;
    [UIView commitAnimations];
}


#pragma mark - Buttons

-(IBAction)btnRefresh:(id)sender {
    fwTable.alpha = 0.0;
    [self showLoadingView];
    
    // clean the arrays
    [fwdate removeAllObjects];
    [fwaddress removeAllObjects];
    [fwsuburb removeAllObjects];
    [fwpcode removeAllObjects];

    [self grabFireworks];
    [self reloadItems];
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table helpers

-(void)reloadItems {
    [fwTable reloadData];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [fwdate count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FireworksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FireworksCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"FireworksCell" bundle:nil] forCellReuseIdentifier:@"FireworksCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FireworksCell"];
    }
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *suburbLabel = (UILabel *)[cell viewWithTag:3];
    UIImageView *fwImage = (UIImageView *)[cell viewWithTag:4];

    colourCounter++;
    if (colourCounter >= [colours count]) {
        colourCounter = 0;
    }
    fwImage.image = [UIImage imageNamed:[colours objectAtIndex:colourCounter]];
    
    NSString *_date = [fwdate objectAtIndex:indexPath.row];
    [dateLabel setText:_date];
    
    NSString *_address = [fwaddress objectAtIndex:indexPath.row];
    [addressLabel setText:_address];

    NSString *_suburb = [fwsuburb objectAtIndex:indexPath.row];
    [suburbLabel setText:_suburb];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fulladdress = [NSString stringWithFormat:@"%@ %@ %@",[fwaddress objectAtIndex:indexPath.row],[fwsuburb objectAtIndex:indexPath.row],[fwpcode objectAtIndex:indexPath.row]];
    
    NSString *_fwdate = [fwdate objectAtIndex:indexPath.row];
    NSString *_fwaddress = [fwaddress objectAtIndex:indexPath.row];
    NSString *_fwsuburb = [fwsuburb objectAtIndex:indexPath.row];
    NSString *_fwpcode = [fwpcode objectAtIndex:indexPath.row];
    
    // Navigation logic may go here. Create and push another view controller.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_fwdate forKey:@"fwdate"];
    [userDefaults setObject:_fwaddress forKey:@"fwaddress"];
    [userDefaults setObject:_fwsuburb forKey:@"fwsuburb"];
    [userDefaults setObject:_fwpcode forKey:@"fwpcode"];
    [userDefaults setObject:fulladdress forKey:@"fulladdress"];

    // super hack -- saving to text file as nsuserdefaults isn't working !!!
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"nsuserdefaults.txt"];
    NSString *str = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|",_fwdate,_fwaddress,_fwsuburb,_fwpcode,fulladdress];
    [str writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    
    DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:dvc animated:YES];
}




@end
