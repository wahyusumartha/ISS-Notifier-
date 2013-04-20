//
//  ScheduleListViewController.m
//  ISS-Spot
//
//  Created by Wahyu Sumartha  on 4/20/13.
//  Copyright (c) 2013 Wahyu Sumartha . All rights reserved.
//

#import "ScheduleListViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "AFNetworking.h"
#import "MBProgressHUD.h"

#import "Schedule.h"

@interface ScheduleListViewController ()

@property (nonatomic, strong) MBProgressHUD *networkProgress;

@end

@implementation ScheduleListViewController

@synthesize schedulesTableView = _schedulesTableView;
@synthesize locationManager = _locationManager;
@synthesize networkProgress = _networkProgress;
@synthesize responseArray = _responseArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.responseArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.schedulesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44-20) style:UITableViewStylePlain];
    [self.schedulesTableView setDelegate:self];
    [self.schedulesTableView setDataSource:self];
    [self.view addSubview:self.schedulesTableView];
    
    [self showLoadingProgress];
    
    [self getSchedules];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Click");
}

#pragma mark - UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.responseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Schedule *schedule = [self.responseArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", schedule.riseTime, schedule.duration];
    
    
    return cell;
    
}

#pragma mark - Get Schedule of International Space Station Pass Times
/**
 *  Get Schedules of International Space Station Pass Times
 *      http://open-notify.org/api-doc
 */
- (void)getSchedules
{
    
    NSLog(@"%@", [NSString stringWithFormat:@"http://api.open-notify.org/iss/?lat=%f&lon=%f&alt=%f&n=10", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, self.locationManager.location.altitude]);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.open-notify.org/iss/?lat=%f&lon=%f&alt=%f&n=10", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, self.locationManager.location.altitude]]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dictionary = (NSDictionary *)JSON;
        
        NSArray *responses = [dictionary objectForKey:@"response"];
        
        for (int i = 0; i < responses.count; i++) {
            Schedule *schedule = [[Schedule alloc] init];
            
            [schedule setRiseTimeInTimeStamp:[[[responses objectAtIndex:i] objectForKey:@"risetime"] integerValue]];
            [schedule setDurationRawDataInSeconds:[[[responses objectAtIndex:i] objectForKey:@"duration"] integerValue]];
            
            [self.responseArray addObject:schedule];
            schedule = nil;
        }
        
        responses = nil;
        
        [self.schedulesTableView reloadData];
        
        [self hideLoadingProgress];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error : %@", error);
    }];
    
    [operation start];
}


#pragma mark - Show Loading Progress 
- (void)showLoadingProgress
{
    self.networkProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.networkProgress.labelText = @"Loading";
    
}

#pragma mark - Hide Loading Progress
- (void)hideLoadingProgress
{
    [self.networkProgress hide:YES];
}

@end
