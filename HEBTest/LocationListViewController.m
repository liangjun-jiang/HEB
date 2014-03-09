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

#import "SVProgressHUD.h"

#import "UITableViewCell+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIBarButtonItem+FlatUI.h"

#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"


#pragma mark - Helper method
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
   
    CLLocationCoordinate2D _currentUserCoordinate;
    NSArray *parsedLocation;
}

@property (readonly) CLLocationCoordinate2D currentUserCoordiante;
@property (nonatomic, strong) NSString *msg;
-(void)startUpdatingCurrentLocation;
-(void)queryGooglePlace:(CLLocationCoordinate2D) coord;
@end

@implementation LocationListViewController
@synthesize currentUserCoordiante=_currentUserCoordiante;
@synthesize isSettingDefault;
@synthesize locationManger = _locationManger;
@synthesize nearbyHebs;
@synthesize msg;
#pragma mark - Data Fetch
-(void)fetchData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    self.nearbyHebs = json[@"results"];

    if ([self.nearbyHebs count] == 0) {
        msg = @"Your Heb is not in our database. Tap to see other HEB ads.";
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        ProductCategoryViewController *productCategoryViewController = [[ProductCategoryViewController alloc] initWithNibName:@"ProductCategoryViewController" bundle:nil];
        productCategoryViewController.storeId = @"202";
        
        
        [self.navigationController pushViewController:productCategoryViewController animated:YES];
        
    } else
        self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [self.tableView reloadData];
}

-(NSString *)findStoreId:(NSInteger)index
{
    NSDictionary *heb = self.nearbyHebs[index];
    NSString *street_name = heb[@"vicinity"];
    
    NSString *digits = [street_name stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet] ];
    
    NSString  *path = [[NSBundle mainBundle] pathForResource:@"street_store" ofType:@"plist"];
    NSMutableArray *storeDicts = [NSMutableArray arrayWithContentsOfFile:path];
    NSString *store_id = @"96";  // this is gonna be a default store id!
    
    if (storeDicts != nil) {
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if  (self){
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
    
    //Set the separator color
    self.tableView.separatorColor = [UIColor cloudsColor];
    
    //Set the background color
    self.tableView.backgroundColor = [UIColor cloudsColor];
    self.tableView.backgroundView = nil;
    
    msg = @"Searching for nearby H-E-B...";
    
    self.navigationItem.title = @"Nearby H-E-Bs";
    UIBarButtonItem *mapBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(displayPlacemarks)];
    self.navigationItem.rightBarButtonItem = mapBarItem;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor peterRiverColor]
                                  highlightedColor:[UIColor belizeHoleColor]
                                      cornerRadius:3
                                   whenContainedIn:[UINavigationBar class], nil];
    [self.navigationItem.rightBarButtonItem removeTitleShadow];
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont: [UIFont boldFlatFontOfSize:18]};
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    _currentUserCoordiante = kCLLocationCoordinate2DInvalid;
    [self startUpdatingCurrentLocation];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if (self.isSettingDefault) {
//        [SVProgressHUD showSuccessWithStatus:@"Will be effective next time you open the app."];
//    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI control

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
    if (self.nearbyHebs!= nil && [self.nearbyHebs count]!=0) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [self unlockUI];
            PlacemarkViewController *plvc = [[PlacemarkViewController alloc] initWithPlacemarks:self.nearbyHebs];
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
        [SVProgressHUD showErrorWithStatus:message];
        
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
    if ((self.nearbyHebs !=nil) && [self.nearbyHebs count] >0)
        return [self.nearbyHebs count];
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
//        cell = [UITableViewCell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor] style:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.cornerRadius = 5.f; //Optional
//        cell.separatorHeight = 2.f; //Optional

        
    }
    if ([self.nearbyHebs count] > 0) {
        
        NSDictionary *hebAddress = self.nearbyHebs[indexPath.row];
        NSString *queriedAddress = hebAddress[@"vicinity"];
        if (isSettingDefault) {
            NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
            NSString *storeAddress = [defaults objectForKey:@"DEFAULT_HEB_NAME"];
            if ([storeAddress isEqualToString:queriedAddress]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else
                cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = queriedAddress;
    } else {
        //TODO: WE SHOULD JUST GUAID THE USER TO THE DEFAULT PAGE
        cell.textLabel.text = msg;
         NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"USE_DEFAULT_LOCATION"];
        [defaults synchronize];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    if (isSettingDefault) {
        if ([self.nearbyHebs count] > 0) {
        
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            
            NSDictionary *storedHEB = [defaults objectForKey:@"DEFAULT_HEB"];
            
            __block NSInteger cellIndex = 0;
            [self.nearbyHebs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([storedHEB[@"id"] isEqualToString:((NSDictionary*)obj)[@"id"]]) {
                    cellIndex = idx;
                    *stop = YES;
                }
            }];
            
            NSDictionary *currentHEB = self.nearbyHebs[indexPath.row];
          
            if (![storedHEB isEqualToDictionary:currentHEB]) {
                UITableViewCell *newCell = [tableView  cellForRowAtIndexPath:indexPath];
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:indexPath];
                oldCell.accessoryType = UITableViewCellAccessoryNone;
             
                // I DN'T GET IT WHY HAS TO BE SET SO  MANY TIMES
                [defaults setBool:YES forKey:@"USE_DEFAULT_LOCATION"];
                [defaults setObject:[self findStoreId:indexPath.row] forKey:@"DEFAULT_HEB_ID"];
                [defaults setObject:newCell.textLabel.text forKey:@"DEFAULT_HEB_NAME"];
                [defaults setObject:currentHEB forKey:@"DEFAULT_HEB"];
                [defaults synchronize];
            }
        }
        
    } else {
        if ([self.nearbyHebs count] == 0) {
            ProductCategoryViewController *productCategoryViewController = [[ProductCategoryViewController alloc] initWithNibName:@"ProductCategoryViewController" bundle:nil];
            productCategoryViewController.storeId = @"202";
            
            
            [self.navigationController pushViewController:productCategoryViewController animated:YES];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }
        else 
        {
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
//        _locationManger.purpose = @"This is used to search your nearby H-E-B";
    }
    [_locationManger startUpdatingLocation];
    
//    [SVProgressHUD showWithStatus:@"Searching..."];
}

-(void)stopUpdatingCurrentLocation
{
//    [SVProgressHUD dismiss];
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
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}


#pragma mark - Query google Place
-(void)queryGooglePlace:(CLLocationCoordinate2D)coord
{
    NSString *placeUrlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=6000&types=grocery_or_supermarket&name=heb&sensor=false&key=AIzaSyDI9oKyroNMwBTCSWEoSgVfrKtvQ10S3jw", coord.latitude, coord.longitude];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:placeUrlString]];
        [self performSelectorOnMainThread:@selector(fetchData:) withObject:data waitUntilDone:YES];
                        
    });
                              
}


@end
