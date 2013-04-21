//
//  MainViewController.m
//  ISS-Spot
//
//  Created by Wahyu Sumartha  on 4/20/13.
//  Copyright (c) 2013 Wahyu Sumartha . All rights reserved.
//

#import "MainViewController.h"

#import "AppDelegate.h"
#import "SecureUDID.h"
#import "AFNetworking.h"

#import "ScheduleListViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MainViewController () {
    GMSMapView *_mapView;
    GMSMarker *_marker;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_locationManager) {
        [_locationManager setDelegate:self];
    }
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:50/255.f green:58/255.f blue:69/255.f alpha:1.0]];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_locationManager setDelegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:@"ISS Spot"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Schedules" style:UIBarButtonItemStyleBordered target:self action:@selector(openSchedule:)];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude zoom:6];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44-20) camera:camera];
    [self.view addSubview:_mapView];
    
    /**
     *  Get ISS Location
     */
    [self issLocation];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManager Delegate 
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    /**
     *  Register User
     */
//    [self sendUser:location.coordinate.latitude withLongiture:location.coordinate.longitude];
    
    // Send Device Token
//    [self sendDeviceTokenWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];

}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    NSLog(@"Error : %@", [error description]);
}

#pragma mark - Register User 
- (void)sendUser:(float)latitude withLongiture:(float)longitude {
    
    /**
     *  Check Flag
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey:@"registerOrUpdateUser"] == YES) {
        /**
         *  Get UDID
         */
        NSString *domain = @"com.wahyusumartha.issspot";
        NSString *key = @"secret";
        NSString *identifier = [SecureUDID UDIDForDomain:domain usingKey:key];
        
        /**
         *  Post Data
         */
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://sapp:Awes0meSpace@173.192.102.34/space/storeUser"]];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"http://sapp:Awes0meSpace@173.192.102.34/space/storeUser"
                                                          parameters:@{@"fbId":[NSString stringWithFormat:@"%@", identifier],
                                        @"lat":[NSString stringWithFormat:@"%f", latitude], @"lng":[NSString stringWithFormat:@"%f", longitude]}];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Print the response body in text
            NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        
        /**
         *  Set Flag
         */
        [userDefaults setBool:NO forKey:@"registerOrUpdateUser"];
        [userDefaults synchronize];

    }
    
    userDefaults = nil;

}

#pragma mark - Send Device Token
- (void)sendDeviceTokenWithLatitude:(float)latitude andLongitude:(float)longitude
{
    /**
     *  Get UDID
     */
    NSString *domain = @"com.wahyusumartha.issspot";
    NSString *key = @"secret";
    NSString *identifier = [SecureUDID UDIDForDomain:domain usingKey:key];
    
    /*
     *  Get Device Token
     */
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *deviceToken = [appDelegate deviceToken];
    
    /**
     *  Post Data
     */
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://sapp:Awes0meSpace@173.192.102.34/space/tokenUpdate"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://sapp:Awes0meSpace@173.192.102.34/space/tokenUpdate"
                                                      parameters:@{@"fbId":[NSString stringWithFormat:@"%@", identifier],
                                    @"deviceToken":[NSString stringWithFormat:@"%@", deviceToken], @"lat":[NSString stringWithFormat:@"%f", latitude], @"lng":[NSString stringWithFormat:@"%f", longitude]}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
}

#pragma mark - Open Schedule 
- (void)openSchedule:(id)sender
{
    ScheduleListViewController *scheduleViewController = [[ScheduleListViewController alloc] init];
    scheduleViewController.locationManager = _locationManager;
    [self.navigationController pushViewController:scheduleViewController animated:YES];
    
}

#pragma mark - Get ISS Location 
- (void)issLocation
{
    /**
     *  Get ISS Location
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.open-notify.org/iss-now/"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dictionary = (NSDictionary *)JSON;
        
        NSArray *responses = [dictionary objectForKey:@"iss_position"];
        
        NSLog(@"Responses : %@", responses);
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[dictionary objectForKey:@"iss_position"] objectForKey:@"latitude"] doubleValue] longitude:[[[dictionary objectForKey:@"iss_position"] objectForKey:@"longitude"] doubleValue] zoom:1];
        
        [_mapView setCamera:camera];
        
        _marker = [[GMSMarker alloc] init];
        _marker.position = CLLocationCoordinate2DMake([[[dictionary objectForKey:@"iss_position"] objectForKey:@"latitude"] doubleValue], [[[dictionary objectForKey:@"iss_position"] objectForKey:@"longitude"] doubleValue]);
        _marker.title = @"ISS Location";
        _marker.map = _mapView;
        
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(relocateISS:) userInfo:nil repeats:YES];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error : %@", error);
    }];
    
    [operation start];

}

- (void)relocateISS:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    /**
     *  Get ISS Location
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.open-notify.org/iss-now/"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dictionary = (NSDictionary *)JSON;
        
        NSArray *responses = [dictionary objectForKey:@"iss_position"];
        
        NSLog(@"Responses : %@", responses);
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[dictionary objectForKey:@"iss_position"] objectForKey:@"latitude"] doubleValue] longitude:[[[dictionary objectForKey:@"iss_position"] objectForKey:@"longitude"] doubleValue] zoom:1];
        
        [_mapView setCamera:camera];
        
        _marker.position = CLLocationCoordinate2DMake([[[dictionary objectForKey:@"iss_position"] objectForKey:@"latitude"] doubleValue], [[[dictionary objectForKey:@"iss_position"] objectForKey:@"longitude"] doubleValue]);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error : %@", error);
    }];
    
    [operation start];
}


@end
