//
//  AppTabbarController.m
//  kvtemplate
//
//  Created by kevin on 2020/6/6.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppTabbarController.h"

#import "HomeViewController.h"
#import "ChannelViewController.h"
#import "PersonalViewController.h"
#import "DiscoverViewController.h"

#import "AppNavigationController.h"

@interface AppTabbarController ()

@end

@implementation AppTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;

    NSArray<NSString *> *titles = @[@"home", @"discaover", @"channel", @"personal"];
    NSArray<NSString *> *icons = @[@"", @"", @"", @""];
    NSArray<NSString *> *selecteicons = @[@"", @"", @"", @""];
    NSMutableArray<UINavigationController *> *vcs = NSMutableArray.array;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
//        NSString *icon = icons[i];
//        NSString *selecteIcon = selecteicons[i];
        UIImage *image = nil;
        UIImage *selecteImage = nil;
        
        UIViewController *vc = nil;
        if (i == 0) {
            vc = [[HomeViewController alloc] init];
        } else if (i == 1) {
            vc = [[DiscoverViewController alloc] init];
        } else if (i == 2) {
            vc = [[ChannelViewController alloc] init];
        } else if (i == 3) {
            vc = [[PersonalViewController alloc] init];
        }
        vc.title = title;
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selecteImage];
        
        AppNavigationController *nav = [[AppNavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:nav];
    }
    self.viewControllers = vcs;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
