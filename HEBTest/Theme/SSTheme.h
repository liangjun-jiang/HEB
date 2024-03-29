/*
     File: SSTheme.h
 Abstract: The SSTheme protocol that must be adopted by themes and the SSThemeManager that gives access to the current theme.
  Version: 1.0
 
 
 
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SSThemeTab) {
    SSThemeTabDoor,
    SSThemeTabPower,
    SSThemeTabControls,
};

@protocol SSTheme <NSObject>

- (UIColor *)mainColor;
- (UIColor *)highlightColor;
- (UIColor *)shadowColor;
- (UIColor *)backgroundColor;

- (UIColor *)baseTintColor;
- (UIColor *)accentTintColor;

- (UIColor *)switchThumbColor;
- (UIColor *)switchOnColor;
- (UIColor *)switchTintColor;

- (CGSize)shadowOffset;

- (UIImage *)topShadow;
- (UIImage *)bottomShadow;

- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics;
- (UIImage *)barButtonBackgroundForState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;

- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics;

- (UIImage *)searchBackground;
- (UIImage *)searchFieldImage;
- (UIImage *)searchImageForIcon:(UISearchBarIcon)icon state:(UIControlState)state;
- (UIImage *)searchScopeButtonBackgroundForState:(UIControlState)state;
- (UIImage *)searchScopeButtonDivider;

- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetrics;

- (UIImage *)tableBackground;

- (UIImage *)onSwitchImage;
- (UIImage *)offSwitchImage;

- (UIImage *)sliderThumbForState:(UIControlState)state;
- (UIImage *)sliderMinTrack;
- (UIImage *)sliderMaxTrack;
- (UIImage *)speedSliderMinImage;
- (UIImage *)speedSliderMaxImage;

- (UIImage *)progressTrackImage;
- (UIImage *)progressProgressImage;

- (UIImage *)stepperBackgroundForState:(UIControlState)state;
- (UIImage *)stepperDividerForState:(UIControlState)state;
- (UIImage *)stepperIncrementImage;
- (UIImage *)stepperDecrementImage;

- (UIImage *)buttonBackgroundForState:(UIControlState)state;

- (UIImage *)tabBarBackground;
- (UIImage *)tabBarSelectionIndicator;
// One of these must return a non-nil image for each tab:
- (UIImage *)imageForTab:(SSThemeTab)tab;
- (UIImage *)finishedImageForTab:(SSThemeTab)tab selected:(BOOL)selected;

- (UIImage *)doorImageForState:(UIControlState)state;

@end

@interface SSThemeManager : NSObject

+ (id <SSTheme>)sharedTheme;

+ (void)customizeAppAppearance;
+ (void)customizeView:(UIView *)view;
+ (void)customizeTableView:(UITableView *)tableView;
+ (void)customizeTabBarItem:(UITabBarItem *)item forTab:(SSThemeTab)tab;
+ (void)customizeDoorButton:(UIButton *)button;

@end
