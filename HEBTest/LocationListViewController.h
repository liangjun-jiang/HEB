//
//  LocationListViewController.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    BOOL isSettingDefault;
    CLLocationManager *_locationManger;
}

@property (strong,nonatomic) CLLocationManager *locationManger;
@property (strong,nonatomic) NSMutableArray *locationList;
@property (strong, nonatomic) NSIndexPath *selectedPath;
@property (strong, nonatomic) NSMutableArray *placeMarkers;
@property (strong, nonatomic) NSMutableArray *latlongs;
@property (strong, nonatomic) NSArray *nearbyHebs;
@property (assign, nonatomic) BOOL isSettingDefault;

@end
