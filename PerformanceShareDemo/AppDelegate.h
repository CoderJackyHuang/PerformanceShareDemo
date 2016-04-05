//
//  AppDelegate.h
//  PerformanceShareDemo
//
//  Created by huangyibiao on 16/3/31.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) dispatch_queue_t clipImageQueue;
@property (nonatomic, strong, readonly) NSCache *memoryCache;

@end

