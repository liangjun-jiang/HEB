//
//  PlacemarkViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/17/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "PlacemarkViewController.h"
@interface MapViewAnnotation:NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
-(id)initWithTitle:(NSString*)mTitle withCoordinate:(CLLocationCoordinate2D )c2d;
@end


@implementation MapViewAnnotation
@synthesize coordinate, title;
-(id)initWithTitle:(NSString *)mTitle withCoordinate:(CLLocationCoordinate2D )c2d
{
    [super init];
    coordinate = c2d;
    title = mTitle;
    
    return self;
}

-(void)dealloc{
    [title release];
    [super dealloc];
}

@end

@implementation PlacemarkViewController
@synthesize placemarks=_placemarks, mapView=_mapView;

#pragma MKAnnotation Delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"H-E-B";
    MKPinAnnotationView *annotionView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    annotionView.enabled = YES;
    annotionView.canShowCallout = YES;
    
    return annotionView;
}
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *aV = [views objectAtIndex:0];
    id <MKAnnotation> mp = [aV annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 10000, 10000);
    [mapView setRegion:region];
    [mapView selectAnnotation:mp animated:YES];
}


#pragma init
-(id)initWithPlacemarks:(NSArray *)placemarks
{
    [super init];
    self.placemarks = placemarks;
    
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (id currentObj in self.placemarks){
        if ([currentObj isKindOfClass:[NSDictionary class]]) {
            CLLocationCoordinate2D location;
            location.latitude = [[[currentObj objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
            location.longitude = [[[currentObj objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
            MapViewAnnotation *aN = [[MapViewAnnotation alloc] initWithTitle:@"H-E-B" withCoordinate:location];
            [self.mapView addAnnotation:aN];
            [aN release];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.mapView = nil;
    self.placemarks = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.mapView = nil;
    self.placemarks = nil;
    [_placemarks release];
    [_mapView release];
    [super dealloc];
}




@end
