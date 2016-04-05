//
//  HYBNetGridModel.h
//  PerformanceShareDemo
//
//  Created by huangyibiao on 16/4/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYBNetGridModel : NSObject

@property (nonatomic, copy) NSString *mainImageUrl;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *headImageUrl;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, strong) NSArray *adImageUrls;

@property (nonatomic, assign) NSUInteger currentItem;

@end
