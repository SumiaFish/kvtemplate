//
//  KVThemeMap.h
//  kvtemplate
//
//  Created by kevin on 2020/6/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SwiftTheme/SwiftTheme-Swift.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @interface CALayer (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeCGColorPicker * _Nullable theme_backgroundColor;
 @property (nonatomic, strong) ThemeCGFloatPicker * _Nullable theme_borderWidth;
 @property (nonatomic, strong) ThemeCGColorPicker * _Nullable theme_borderColor;
 @property (nonatomic, strong) ThemeCGColorPicker * _Nullable theme_shadowColor;
 @property (nonatomic, strong) ThemeCGColorPicker * _Nullable theme_strokeColor;
 @property (nonatomic, strong) ThemeCGColorPicker * _Nullable theme_fillColor;
 @end
 
 
 @interface UIActivityIndicatorView (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_color;
 @property (nonatomic, strong) ThemeActivityIndicatorViewStylePicker * _Nullable theme_activityIndicatorViewStyle;
 @end
 
 
 @interface UIApplication (SWIFT_EXTENSION(SwiftTheme))
 - (void)theme_setStatusBarStyle:(ThemeStatusBarStylePicker * _Nonnull)picker animated:(BOOL)animated;
 @end
 
 
 @interface UIBarAppearance (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_backgroundColor;
 @property (nonatomic, strong) ThemeImagePicker * _Nullable theme_backgroundImage;
 @property (nonatomic, strong) ThemeBlurEffectPicker * _Nullable theme_backgroundEffect;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_shadowColor;
 @property (nonatomic, strong) ThemeImagePicker * _Nullable theme_shadowImage;
 @end


 @interface UIBarButtonItem (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_tintColor;
 @end


 @interface UIBarItem (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeImagePicker * _Nullable theme_image;
 - (void)theme_setTitleTextAttributes:(ThemeStringAttributesPicker * _Nullable)picker forState:(UIControlState)state;
 @end


 @interface UIButton (SWIFT_EXTENSION(SwiftTheme))
 - (void)theme_setImage:(ThemeImagePicker * _Nullable)picker forState:(UIControlState)state;
 - (void)theme_setBackgroundImage:(ThemeImagePicker * _Nullable)picker forState:(UIControlState)state;
 - (void)theme_setTitleColor:(ThemeColorPicker * _Nullable)picker forState:(UIControlState)state;
 @end
 
 
 @interface UIImageView (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeImagePicker * _Nullable theme_image;
 @end




 @interface UILabel (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeFontPicker * _Nullable theme_font;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_textColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_highlightedTextColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_shadowColor;
 @property (nonatomic, strong) ThemeStringAttributesPicker * _Nullable theme_textAttributes;
 @end


 @interface UINavigationBar (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeBarStylePicker * _Nullable theme_barStyle;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_barTintColor;
 @property (nonatomic, strong) ThemeStringAttributesPicker * _Nullable theme_titleTextAttributes;
 @property (nonatomic, strong) ThemeStringAttributesPicker * _Nullable theme_largeTitleTextAttributes;
 @property (nonatomic, strong) ThemeNavigationBarAppearancePicker * _Nullable theme_standardAppearance SWIFT_AVAILABILITY(tvos,introduced=13.0) SWIFT_AVAILABILITY(ios,introduced=13.0);
 @property (nonatomic, strong) ThemeNavigationBarAppearancePicker * _Nullable theme_compactAppearance SWIFT_AVAILABILITY(tvos,introduced=13.0) SWIFT_AVAILABILITY(ios,introduced=13.0);
 @property (nonatomic, strong) ThemeNavigationBarAppearancePicker * _Nullable theme_scrollEdgeAppearance SWIFT_AVAILABILITY(tvos,introduced=13.0) SWIFT_AVAILABILITY(ios,introduced=13.0);
 @end




 @interface UIPageControl (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_pageIndicatorTintColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_currentPageIndicatorTintColor;
 @end
 
 
 @interface UIProgressView (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_progressTintColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_trackTintColor;
 @end




 @interface UIRefreshControl (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeStringAttributesPicker * _Nullable theme_titleAttributes;
 @end


 @interface UIScrollView (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeScrollViewIndicatorStylePicker * _Nullable theme_indicatorStyle;
 @end


 @interface UISearchBar (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeBarStylePicker * _Nullable theme_barStyle;
 @property (nonatomic, strong) ThemeKeyboardAppearancePicker * _Nullable theme_keyboardAppearance;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_barTintColor;
 @end


 @interface UISegmentedControl (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_selectedSegmentTintColor;
 - (void)theme_setTitleTextAttributes:(ThemeStringAttributesPicker * _Nullable)picker forState:(UIControlState)state;
 @end


 @interface UISlider (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_thumbTintColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_minimumTrackTintColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_maximumTrackTintColor;
 @end


 @interface UISwitch (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_onTintColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_thumbTintColor;
 @end


 @interface UITabBar (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeBarStylePicker * _Nullable theme_barStyle;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_unselectedItemTintColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_barTintColor;
 @end


 @interface UITabBarItem (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeImagePicker * _Nullable theme_selectedImage;
 @end


 @interface UITableView (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_separatorColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_sectionIndexColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_sectionIndexBackgroundColor;
 @end




 @interface UITextField (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeFontPicker * _Nullable theme_font;
 @property (nonatomic, strong) ThemeKeyboardAppearancePicker * _Nullable theme_keyboardAppearance;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_textColor;
 @property (nonatomic, strong) ThemeStringAttributesPicker * _Nullable theme_placeholderAttributes;
 @end


 @interface UITextView (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeFontPicker * _Nullable theme_font;
 @property (nonatomic, strong) ThemeKeyboardAppearancePicker * _Nullable theme_keyboardAppearance;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_textColor;
 @end


 @interface UIToolbar (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeBarStylePicker * _Nullable theme_barStyle;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_barTintColor;
 @end


 @interface UIView (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeCGFloatPicker * _Nullable theme_alpha;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_backgroundColor;
 @property (nonatomic, strong) ThemeColorPicker * _Nullable theme_tintColor;
 @end


 @interface UIVisualEffectView (SWIFT_EXTENSION(SwiftTheme))
 @property (nonatomic, strong) ThemeVisualEffectPicker * _Nullable theme_effect;
 @end
 
 */

@interface KVTheme : NSObject

@property (assign, nonatomic) UIStatusBarStyle statuBarStyle;

@property (strong, nonatomic) UIColor *bgColor;

@property (strong, nonatomic) UIColor *tinColor;

@property (strong, nonatomic) UIColor *separatorColor;

@property (strong, nonatomic) UIColor *textColor;

@property (strong, nonatomic) UIColor *textHilightColor;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIImage *hilightImage;

@end

@interface KVThemeMap : NSObject

@property (class, assign, nonatomic) NSTimeInterval animationDuration;

@property (class, strong, nonatomic, readonly) NSMutableDictionary<NSNumber *, KVTheme *> *themes;

+ (void)switchTo:(NSInteger)type;
+ (void)switchToNext;
+ (void)switchNight:(BOOL)isToNight;

+ (BOOL)isNight;

+ (void)restoreLastTheme;
+ (void)saveLastTheme;

@end

NS_ASSUME_NONNULL_END
