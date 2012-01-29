//
//  PlacemarkViewController.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/17/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PlacemarkViewController : UIViewController <MKMapViewDelegate>
{
    NSArray *_placemarks;
    MKMapView *_mapView;
}

@property (nonatomic, retain) NSArray *placemarks;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

// designed initilizers

-(id)initWithPlacemarks:(NSArray *)placemarks;
 
@end
