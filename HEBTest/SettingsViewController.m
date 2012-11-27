//
//  SettingsViewController.m
//  Reminder
//
//  Created by LIANGJUN JIANG on 11/17/12.
//
//

#import "SettingsViewController.h"
#import "AboutListViewController.h"
#import "SwitchTableCell.h"
#import "LocationListViewController.h"

#define REGION_SECTION 0
#define ABOUT_SECTION 1

#define TITLE @"title"
#define VALUE @"placeholder"

@interface SettingsViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableDictionary *contentList;
@property (nonatomic, strong) NSString *defaultHeb;
@property (nonatomic, assign) BOOL onOff;
@end

@implementation SettingsViewController
@synthesize contentList;
@synthesize defaultHeb, onOff;

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    onOff = [defaults boolForKey:@"USE_DEFAULT_LOCATION"];
    if (onOff) {
        defaultHeb = [defaults objectForKey:@"DEFAULT_HEB_NAME"];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Settings", @"Settings");
    
//    [SSThemeManager customizeTableView:self.tableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    
    self.contentList = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:plistPath]
                                                                 options:NSPropertyListMutableContainers
                                                                  format:NULL
                                                                   error:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.contentList allKeys] objectAtIndex:section];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.contentList allKeys] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [[self.contentList allKeys] objectAtIndex:section];
    return [[self.contentList objectForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    static NSString *RegionCellIdentifier = @"RegionCell";
    static NSString *AboutCellIdentifier = @"AboutCell";
    UITableViewCell *cell = nil;
    NSString *key = [[self.contentList allKeys] objectAtIndex:section];
    NSString *title = [[[self.contentList objectForKey:key] objectAtIndex:row] objectForKey:TITLE];
    
    if (section == REGION_SECTION) {
        SwitchTableCell *regionCell = (SwitchTableCell*)[tableView dequeueReusableCellWithIdentifier:RegionCellIdentifier];
        if (regionCell == nil) {
            regionCell = [[SwitchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RegionCellIdentifier];
            
        }
        regionCell.textLabel.text = title;
        if (onOff) {
            regionCell.detailTextLabel.text = defaultHeb;
            regionCell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
        }
        
        regionCell.onOffSwitch.on = onOff;
        [regionCell.onOffSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
        cell = regionCell;
    } else {
        UITableViewCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier];
        if (aboutCell == nil) {
            aboutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AboutCellIdentifier];
            aboutCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        aboutCell.textLabel.text = title;
        cell = aboutCell;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ABOUT_SECTION) {
        AboutListViewController *about = [[AboutListViewController alloc] initWithNibName:@"AboutListViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
    } else
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - OnOffSwitch method
- (void)onSwitch:(id)sender
{
    UISwitch *settingSwitch = (UISwitch *)sender;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (settingSwitch.on) {
        [defaults setBool:settingSwitch.on forKey:@"USE_DEFAULT_LOCATION"];
        [defaults synchronize];
        
        LocationListViewController *locationList = [[LocationListViewController alloc] initWithNibName:@"LocationListViewController" bundle:nil];
        locationList.isSettingDefault = YES;
        [self.navigationController pushViewController:locationList animated:YES];
    } else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.detailTextLabel.text = @"";
        [defaults setBool:!settingSwitch.on forKey:@"USER_DEFAULT_LOCATION"];
        [defaults synchronize];
        
    }
}

@end
