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

#import "NSString+Encrypt.h"

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
    
    [self testEncrypt];
}

- (void)testEncrypt {
    
#if 0
    NSString *string = @"hello";
    kLog(@"明文: %@", string);
    NSString *aesEncrypt = [NSString aes128CBCEncrypt:string key:@"key" iv:@"iv"];
    kLog(@"aes加密后: %@", aesEncrypt);
    NSString *md5 = [NSString md5:aesEncrypt key:@"key"];
    kLog(@"md5加密后: %@", md5);
    NSString *base64 = [NSString encodeBase64String:md5];
    kLog(@"base64加密后: %@", base64);
#endif
    
#if 0
    NSString *string = @"hello";
    kLog(@"明文: %@", string);
    NSString *aesEncrypt = [NSString aes128CBCEncrypt:string key:@"key" iv:@"iv"];
    kLog(@"aes加密后: %@", aesEncrypt);
    NSString *base64 = [NSString encodeBase64String:aesEncrypt];
    kLog(@"base64加密后: %@", base64);
    NSString *decodeBase64 = [NSString decodeBase64String:base64];
    kLog(@"base64解密后: %@", decodeBase64);
    NSString *aesDecrypt = [NSString aes128CBCDecrypt:decodeBase64 key:@"key" iv:@"iv"];
    kLog(@"aes解密后: %@", aesDecrypt);
#endif
    
    NSString *string = @"hello";
    kLog(@"明文: %@", string);
    NSString *aesEncrypt = [NSString aes128CBCEncrypt:string key:@"key" iv:@"iv"];
    kLog(@"aes加密后: %@", aesEncrypt);
    NSInteger min = ((uint64_t)(NSDate.date.timeIntervalSince1970))/60;
    NSString *params = [NSString stringWithFormat:@"%@%@", aesEncrypt, @(min).stringValue];
    NSString *md5 = [NSString md5:params key:@"key"];
    kLog(@"md5加密后: %@", md5);
    
    
    
    
    // 给后台发送 aesEncrypt, min, md5, 涉及网络传输 最好做一个base64
//    [self sendTosrvice:aesEncrypt min:min md5:md5];
    
    // 模拟数据被篡改
    [self sendTosrvice:[aesEncrypt stringByAppendingString:@"0"] min:min md5:md5];
}

- (void)sendTosrvice:(NSString *)aesEncrypt min:(NSInteger)min md5:(NSString *)md5 {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 给后台拿到 aesEncrypt, min, md5
        NSInteger min1 = ((uint64_t)(NSDate.date.timeIntervalSince1970))/60;
        
        if (labs(min1 - min) > 1) {
            // 不超过一分钟,否则无效
        } else {
            min1 = min;
        }
        
        NSString *params1 = [NSString stringWithFormat:@"%@%@", aesEncrypt, @(min1).stringValue];
        NSString *md51 = [NSString md5:params1 key:@"key"];
        if ([md5 isEqualToString:md51]) {
            kLog(@"有效请求");
            NSString *aesDecrypt = [NSString aes128CBCDecrypt:aesEncrypt key:@"key" iv:@"iv"];
            kLog(@"前端传过来的数据为: %@", aesDecrypt);
        } else {
            /// 数据被篡改
            kLog(@"非法请求");
        }
        
    });
    
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
