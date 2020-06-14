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

@end

@implementation HomeViewController
{
    AppNetworking *task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.navigationController.navigationBar.hidden = NO;
    
    [self button];
}

- (void)pushAction {
    [self.navigationController pushViewController:[CTMediator.sharedInstance detailController] animated:YES];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.view addSubview:_button];
        _button.frame = CGRectMake(0, 0, 100, 40);
        _button.center = self.view.center;
        [_button setTitle:@"push" forState:0];
        [_button addTarget:self action:@selector(pushAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

@end
