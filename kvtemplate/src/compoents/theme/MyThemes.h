//
//  MyThemes.h
//  SwiftTheme
//
//  Created by Gesen on 16/5/26.
//  Copyright © 2016年 Gesen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SwiftTheme/SwiftTheme-Swift.h>

//#define globalStatusBarStringStyles @[@"LightContent", @"Default", @"LightContent", @"LightContent"]
//
//#define globalBackgroundColorPicker [ThemeColorPicker pickerWithColors:@[@"#fff", @"#fff", @"#fff", @"#292b38"]]
//
//#define globalTextColorPicker [ThemeColorPicker pickerWithColors:@[@"#000", @"#000", @"#000", @"#ECF0F1"]]
//
//#define globalBarTextColors @[@"#FFF", @"#000", @"#FFF", @"#FFF"]
//
//#define globalBarTextColorPicker [ThemeColorPicker pickerWithColors:globalBarTextColors]
//
//#define globalBarTintColorPicker [ThemeColorPicker pickerWithColors: @[@"#EB4F38", @"#F4C600", @"#56ABE4", @"#01040D"]]

#define globalStatusBarStringStyles @[@"Default", @"LightContent"]

#define globalBackgroundColorPicker [ThemeColorPicker pickerWithColors:@[@"#292b38", @"#fff"]]

#define globalSectionHeaderBackgroundColorPicker [ThemeColorPicker pickerWithColors:@[@"#8B0000", @"#f00"]]

#define globalTextColorPicker [ThemeColorPicker pickerWithColors:@[@"#ECF0F1", @"#000"]]

#define globalBarTextColors @[@"#000", @"#000"]

#define globalBarTextColorPicker [ThemeColorPicker pickerWithColors:globalBarTextColors]

#define globalBarTintColorPicker [ThemeColorPicker pickerWithColors: @[@"#01040D", @"#FFF"]]

typedef enum {
    MyThemesTypeRed = 0,
//    MyThemesTypeYellow,
//    MyThemesTypeBlue,
    MyThemesTypeNight
} MyThemesType;

@interface MyThemes : NSObject

+ (void)switchTo:(MyThemesType)type;
+ (void)switchToNext;
+ (void)switchNight:(BOOL)isToNight;

+ (BOOL)isNight;

+ (void)restoreLastTheme;
+ (void)saveLastTheme;

+ (void)conf;

@end
