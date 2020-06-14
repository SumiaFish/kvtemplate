//
//  MyThemes.m
//  SwiftTheme
//
//  Created by Gesen on 16/5/26.
//  Copyright © 2016年 Gesen. All rights reserved.
//

#import "MyThemes.h"

@implementation MyThemes

+ (void)switchTo:(MyThemesType)type {
    [ThemeManager setThemeWithIndex:type];
}

+ (void)switchToNext {
    int next = (int)ThemeManager.currentThemeIndex + 1;
    if (next > 1) { // cycle and without Night
        next = 0;
    }
    [self switchTo:next];
}

+ (void)switchNight:(BOOL)isToNight {
    [self switchTo:isToNight ? MyThemesTypeNight : MyThemesTypeRed];
}

+ (BOOL)isNight {
    return (int)ThemeManager.currentThemeIndex == MyThemesTypeNight;
}

+ (void)restoreLastTheme {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MyThemesType type = (int)[defaults integerForKey:self.lastThemeIndexKey];
    [self switchTo:type];
}

+ (void)saveLastTheme {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:ThemeManager.currentThemeIndex forKey:self.lastThemeIndexKey];
}

+ (void)conf {
    
    ThemeManager.animationDuration = 0;
    
    [MyThemes restoreLastTheme];
       
       // status bar
       
       ThemeStatusBarStylePicker *statusPicker = [ThemeStatusBarStylePicker pickerWithStringStyles:globalStatusBarStringStyles];
       
       [[UIApplication sharedApplication] theme_setStatusBarStyle:statusPicker animated:YES];

       // navigation bar
       
       UINavigationBar *navigationBar = [UINavigationBar appearance];
       
       NSShadow *shadow = [[NSShadow alloc] init];
       shadow.shadowOffset = CGSizeZero;
       
       NSMutableArray *titleAttributes = [NSMutableArray array];
       
       for (NSString *rgba in globalBarTextColors) {
           UIColor *color = [[UIColor alloc] initWithRgba_throws:rgba error:nil];
           NSDictionary *attr = @{
               NSForegroundColorAttributeName: color,
               NSFontAttributeName: [UIFont systemFontOfSize:16],
               NSShadowAttributeName: shadow
           };
           [titleAttributes addObject:attr];
       }
       
       navigationBar.theme_tintColor = globalBarTextColorPicker;
       navigationBar.theme_barTintColor = globalBarTintColorPicker;
       navigationBar.theme_titleTextAttributes = [ThemeStringAttributesPicker pickerWithAttributes:titleAttributes];

       // tab bar
       
       UITabBar *tabBar = [UITabBar appearance];
       tabBar.theme_tintColor = globalBarTextColorPicker;
       tabBar.theme_barTintColor = globalBarTintColorPicker;
}

+ (NSString *)lastThemeIndexKey {
    return [NSString stringWithFormat:@"%@.%@.%@", ([[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"]), NSStringFromClass(self.class), @"lastThemeIndex"];
}

@end
