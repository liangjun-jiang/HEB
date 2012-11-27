//
//  LocationListViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import "LocationListViewController.h"
#import "ProductCategoryViewController.h"
#import "LJHWViewController.h"
#import "PlacemarkViewController.h"
#import "UIImage+Resizing.h"

@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString *)urlAddress;
-(NSData *)toJSON;

@end
@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString *)urlAddress
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlAddress]];
    NSError *error = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error !=nil) {
        return nil;
    }
    
    return result;
}

-(NSData *)toJSON
{
    //parse out the json data
    NSError *error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error !=nil) {
        return nil;
    }
    return result;
}
@end

#define kFarWestAustinCoordinate CLLocationCoordinate2DMake(30.3488, -97.7554)
@interface LocationListViewController() {
@private
    CLLocationManager *_locationManger;
    CLLocationCoordinate2D _currentUserCoordinate;
    
    UIActivityIndicatorView *_currentLocationActivityIndicator;
    
    NSURLConnection *theConnection;
    NSArray *parsedLocation;
}

@property (readonly) CLLocationCoordinate2D currentUserCoordiante;
-(void)startUpdatingCurrentLocation;
//-(IBAction)performCoordinateGeocode:(id)sender;
-(void)queryGooglePlace:(CLLocationCoordinate2D) coord;
@end

@implementation LocationListViewController
@synthesize locationList = _locationList;
@synthesize selectedPath=_selectedPath;
@synthesize currentUserCoordiante=_currentUserCoordiante;
@synthesize placeMarkers=_placeMarkers;
@synthesize isSettingDefault;


-(void)fetchData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *hebs =json[@"results"];
    
    if ([hebs count] == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else
        self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.locationList = [[NSMutableArray alloc] initWithCapacity:[hebs count]];
    self.placeMarkers = [[NSMutableArray alloc] initWithCapacity:[hebs count]];
    if (hebs != nil && [hebs count] !=0) {
        for (NSDictionary *heb in hebs)
        {
            if ([heb[@"name"] isEqualToString:@"H-E-B"]) {
                [self.locationList addObject:heb[@"vicinity"]];
                [self.placeMarkers addObject:heb[@"geometry"]];
            }
        }
    }
    [self.tableView reloadData];
    
}

-(NSString *)findStoreId:(NSInteger)index
{
    NSString *street_name = (self.locationList)[index];
    
    NSString *digits = [street_name stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet] ];
    
    
    NSString  *path = [[NSBundle mainBundle] pathForResource:@"street_store" ofType:@"plist"];
    NSMutableArray *storeDicts = [NSMutableArray arrayWithContentsOfFile:path];
    NSString *store_id = @"96";
    
    if (storeDicts == nil) {
        NSLog(@"can't read path: %@", path);
    } else 
    {    
        for (NSDictionary *store in storeDicts)
        {
            if ([store[@"street_number"] isEqualToString:digits]) {
                store_id = store[@"store_id"];   
            }
        }
    }
    
    return store_id;
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
 
    self.navigationItem.title = @"Nearby H-E-Bs";
    UIBarButtonItem *mapBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(displayPlacemarks)];
    self.navigationItem.rightBarButtonItem = mapBarItem;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.locationList = [NSMutableArray arrayWithArray:@[@"Wait a second ..."]];
    _currentUserCoordiante = kCLLocationCoordinate2DInvalid;
    [self startUpdatingCurrentLocation];
    
    if (isSettingDefault) {
        // we need to find out this guy
        self.selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } else
        self.selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _locationList = nil;
    _placeMarkers = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)lockUI
{
    self.tableView.allowsSelection = NO;
}
-(void)unlockUI
{
    self.tableView.allowsSelection = YES;
}

-(void)displayPlacemarks
{
    if (self.placeMarkers!= nil && [self.placeMarkers count]!=0) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [self unlockUI];
                PlacemarkViewController *plvc = [[PlacemarkViewController alloc] initWithPlacemarks:self.placeMarkers];
                [self.navigationController pushViewController:plvc animated:YES];
            
            });
    }
    
}

// display an error
- (void)displayError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self unlockUI];
        NSString *message;
        switch ([error code]) {
            case kCLErrorGeocodeFoundNoResult:
                message = @"kCLErrorGeoCodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled:
                message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default:
                message = [error description];
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Error occured" 
                                                         message:message 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];
        [alert show];
        
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ((self.locationList !=nil) && [self.locationList count] >0)
        return [self.locationList count];
    else 
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UITableViewCellStyle style = UITableViewCellStyleDefault;
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier];
        
    }
    if ([self.locationList count] > 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.text = (self.locationList)[indexPath.row];
    } else
       cell.textLabel.text = @"Didn't find any H-E-B, you can still test drive this app";
    
    if (isSettingDefault) {
        if (indexPath == self.selectedPath) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else
            cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSettingDefault) {
        if (indexPath != self.selectedPath) {
            UITableViewCell *newCell = [tableView  cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.selectedPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            self.selectedPath = indexPath;
            
            NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[self findStoreId:indexPath.row] forKey:@"DEFAULT_HEB_ID"];
            [defaults setObject:newCell.textLabel.text forKey:@"DEFAULT_HEB_NAME"];
            [defaults synchronize];
            
        }
    } else {
        if ([self.locationList count] == 0) {
            ProductCategoryViewController *productCategoryViewController = [[ProductCategoryViewController alloc] initWithNibName:@"ProductCategoryViewController" bundle:nil];
            productCategoryViewController.storeId = @"202";
            [self.navigationController pushViewController:productCategoryViewController animated:YES];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }
        else 
        {
            self.selectedPath = indexPath;
            ProductCategoryViewController *productCategoryViewController = [[ProductCategoryViewController alloc] initWithNibName:@"ProductCategoryViewController" bundle:nil];
            productCategoryViewController.storeId = [self findStoreId:indexPath.row];
            [self.navigationController pushViewController:productCategoryViewController animated:YES];
        }
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)startUpdatingCurrentLocation
{
    // if location service restriced we do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        return;
    }
    
    if (!_locationManger) {
        _locationManger = [[CLLocationManager alloc] init];
        [_locationManger setDelegate:self];
        _locationManger.distanceFilter = 100.0f; // we don't need to be more accurate than 100m
        _locationManger.purpose = @"This is used to search your nearby H-E-B";
    }
    [_locationManger startUpdatingLocation];
}

-(void)stopUpdatingCurrentLocation
{
    [_locationManger stopUpdatingLocation];
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // if the location is older than 300s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 300)
    {
        return;
    }
    _currentUserCoordinate = [newLocation coordinate];
    
    [self queryGooglePlace:_currentUserCoordinate];
    [self stopUpdatingCurrentLocation];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // stop updating
    [self stopUpdatingCurrentLocation];
    _currentUserCoordiante = kCLLocationCoordinate2DInvalid;
    
    // show the alert
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Error updating";
    alert.message = [error localizedDescription];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
}

/*
-(IBAction)performCoordinateGeocode:(id)sender
{
    [self lockUI];
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    CLLocationCoordinate2D coord = _currentUserCoordinate;
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude] autorelease];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error){
        NSLog(@"ReverseGeocodeLocation:completionHandler: Completion handler called");
        if (error) {
            NSLog(@"Geocode failed with error:%@",error);
            [self displayError:error];
            return ;
        }
        NSLog(@"received place marks:%@", placemark);
        [self displayPlacemarks:placemark];
    }];
    
    
}
*/
-(void)queryGooglePlace:(CLLocationCoordinate2D)coord
{
    NSString *placeUrlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=6000&types=grocery_or_supermarket&name=heb&sensor=false&key=AIzaSyDI9oKyroNMwBTCSWEoSgVfrKtvQ10S3jw", coord.latitude, coord.longitude];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:placeUrlString]];
        [self performSelectorOnMainThread:@selector(fetchData:) withObject:data waitUntilDone:YES];
                        
    });
                              
}


@end
