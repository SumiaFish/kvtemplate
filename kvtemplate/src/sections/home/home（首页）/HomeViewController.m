//
//  HomeViewController.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "HomeViewController.h"

#import "HomePresent.h"

#import "AppTableViewStateView.h"

@interface HomeViewController ()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIButton *switchTheme;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    
    [self button];
    [self switchTheme];
}

- (void)pushAction {
    [self.navigationController pushViewController:[CTMediator.sharedInstance detailController] animated:YES];
}

- (void)switchThemeAction {
    [MyThemes switchToNext];
    [MyThemes saveLastTheme];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.view addSubview:_button];
        _button.frame = CGRectMake(0, 0, 100, 40);
        _button.center = self.view.center;
        [_button setTitle:@"push" forState:0];
        [_button theme_setTitleColor:globalTextColorPicker forState:(UIControlStateNormal)];
        [_button addTarget:self action:@selector(pushAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (UIButton *)switchTheme {
    if (!_switchTheme) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.view addSubview:button];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.button.frame) + 20, 100, 40);
        button.center = CGPointMake(self.view.center.x, button.center.y);
        [button setTitle:@"switch theme" forState:0];
        [button theme_setTitleColor:globalTextColorPicker forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(switchThemeAction) forControlEvents:(UIControlEventTouchUpInside)];
        _switchTheme = button;
    }
    return _switchTheme;
}

@end
