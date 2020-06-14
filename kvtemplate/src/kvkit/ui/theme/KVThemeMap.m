//
//  KVThemeMap.m
//  kvtemplate
//
//  Created by kevin on 2020/6/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVThemeMap.h"

static NSMutableDictionary *KVThemeThemes = nil;

@implementation KVTheme

@end

@implementation KVThemeMap

+ (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    ThemeManager.animationDuration = animationDuration;
}

+ (NSTimeInterval)animationDuration {
    return ThemeManager.animationDuration;
}

+ (NSMutableDictionary<NSNumber *,KVTheme *> *)themes {
    if (!KVThemeThemes) {
        KVThemeThemes = NSMutableDictionary.dictionary;
    }
    return KVThemeThemes;
}

+ (void)switchTo:(NSInteger)type {
    [ThemeManager setThemeWithIndex:type];
}

+ (void)switchToNext {
    int next = (int)ThemeManager.currentThemeIndex + 1;
    if (next > 2) { // cycle and without Night
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
    [defaults synchronize];
}

+ (NSString *)lastThemeIndexKey {
    return [NSString stringWithFormat:@"%@.%@.%@", ([[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"]), NSStringFromClass(self.class), @"lastThemeIndex"];
}

@end
