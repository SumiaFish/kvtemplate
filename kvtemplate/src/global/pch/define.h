//
//  define.h
//  kevin
//
//  Created by kevin on 2020/5/1.
//  Copyright © 2020 com.kv. All rights reserved.
//

#ifndef define_h
#define define_h

#define kDesignWidth (667.f)
#define kDesignHeight (375.f)


/** 屏幕宽 */
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

/** 屏幕高 */
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

/** 按照设计稿比例转换数值 */
#define kConverValue(value) (value/kDesignWidth*kScreenWidth)

/** 判断是否为iPhone */
#define kIsIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/** 判断是否为iPad */
#define kIsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 判断是不是刘海屏 */
#define kIsIPhonexSerious \
(^BOOL { \
  if (@available(iOS 11.0, *)) { \
      if ([UIApplication sharedApplication].windows.count) { \
          return [UIApplication sharedApplication].windows[0].safeAreaInsets.bottom > 0.0; \
      } \
  } \
  return NO; \
}()) \


/** NSUserDefaults */
#define kUserDefaults ([NSUserDefaults standardUserDefaults])

/** NSUserDefaults set and synchronize */
#define kUserDefaultsSet(object, key) \
{ \
[kUserDefaults setObject:object forKey:key]; \
[kUserDefaults synchronize]; \
}

/** NSUserDefaults get */
#define kUserDefaultsGet(key) ([kUserDefaults objectForKey:key])

/** NSUserDefaults remove and synchronize */
#define kUserDefaultsRemove(key) \
{ \
[kUserDefaults removeObjectForKey:key]; \
[kUserDefaults synchronize]; \
}


/** 单例 */
#define kSingletionDeclaration(className) \
\
+ (instancetype _Nullable)shareInstance;


#define kSingletionImplementation(className) \
\
static className *shared##className = nil; \
\
+ (instancetype _Nullable)shareInstance { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
} \
\
- (instancetype _Nullable)copyWithZone:(NSZone *)zone \
{ \
return shared##className; \
}\
\
+ (instancetype _Nullable)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [super allocWithZone:zone]; \
}); \
return shared##className; \
}


/** Log */
#ifdef DEBUG
//#define kLog(format,...) printf("%s #%d: %s\n", __func__, __LINE__, ([[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]))
#define kLog(format,...) NSLog(@"%s #%d: \n%@\n", __func__, __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])
#else
#define kLog(...)
#endif


/** weak self strong self */
#define kWeakSelf __weak typeof(self) weakSelf = self;
#define kStrongSelf __strong typeof(self) type = weakSelf;

#define kWeakInstance(type)  __weak typeof(type) weak##type = type;
#define kStrongInstance(type)  __strong typeof(type) type = weak##type;


/** color */
#define kRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a])
#define kRGB(r, g, b) (kRGBA(1))

/** project info */
#define kBundleId ([[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"]) //获取BundleId
#define kBundleProjectName ([[NSBundle mainBundle].infoDictionary objectForKey:(NSString *)kCFBundleExecutableKey]) //获取工程名称
#define kBundleDisplayName ([[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"]) //获取APP名称
#define kBundleShortVersion ([[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]) // 当前应用软件版本  比如：1.0.1
#define kBundleBuildVersion ([[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"]) // app build版本


/** xib */
#define kViewFromNib(nibName) ([[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].lastObject)


/** CGD */
#define kDispatchTimeOffset(t) (dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC))) // s

#ifndef kDispatchMainThreadTask
#define kDispatchMainQueueTask(block)\
\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

#define kDispatchMainQueue (dispatch_get_main_queue())

#define kDispatchGlobalQueue (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))

#define kDispatchSerialQueue(name)  dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL)

#define KCurrentThread ([NSThread currentThread])

#define kLogCurrentThread \
{ \
    kLog(@"current thread: %@", KCurrentThread); \
} \



/** */
#define kFormatString(format,...) ([NSString stringWithFormat:(format), ##__VA_ARGS__])


/**  */
#define KVSafeRespondsToSelector(target, sel, object) { \
    if ([target respondsToSelector:sel]) { \
        [target performSelector:sel withObject:object]; \
    } \
} \

#endif /* define_h */
