//
//  LocationListViewController.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (strong,nonatomic) NSMutableArray *locationList;
@property (strong, nonatomic) NSIndexPath *selectedPath;


@end
