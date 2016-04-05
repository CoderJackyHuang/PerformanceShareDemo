//
//  HYBNetGridCell.m
//  PerformanceShareDemo
//
//  Created by huangyibiao on 16/4/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBNetGridCell.h"
#import <Masonry.h>
#import <HYBImageCliped.h>
#import <HYBLoopScrollView.h>
#import "UIImageView+WebCache.h"
#import "HYBNetGridModel.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>

@interface HYBNetGridCell ()

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UILabel     *locationLabel;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *userNameLabel;

@property (nonatomic, strong) HYBLoopScrollView *adScrollView;

@property (nonatomic, copy) NSString *mainUrl;
@property (nonatomic, copy) NSString *headUrl;

@end

@implementation HYBNetGridCell

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    __weak __typeof(self) weakSelf = self;
    
    self.mainImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.mainImageView];
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.mas_equalTo(10);
      make.right.mas_equalTo(-10);
      make.width.equalTo(weakSelf.mainImageView.mas_height);
    }];
    //    [self.mainImageView hyb_addCornerRadius:20];
    
    self.locationLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.mas_equalTo(weakSelf.mainImageView);
      make.top.mas_equalTo(weakSelf.mainImageView.mas_bottom).mas_offset(10);
      make.height.mas_equalTo(30);
    }];
    self.locationLabel.numberOfLines = 0;
    
    self.headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(10);
      make.width.height.mas_equalTo(100);
      make.top.mas_equalTo(weakSelf.locationLabel.mas_bottom).offset(10);
    }];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(10);
      make.right.mas_equalTo(-10);
      make.top.mas_equalTo(weakSelf.headImageView.mas_top);
    }];
    
    
    self.adScrollView = [HYBLoopScrollView loopScrollViewWithFrame:CGRectZero imageUrls:nil timeInterval:5 didSelect:^(NSInteger atIndex) {
      
    } didScroll:^(NSInteger toIndex) {
      
    }];
    // 设置为YES,开启优化
    self.adScrollView.shouldAutoClipImageToViewSize = YES;
    [self.contentView addSubview:self.adScrollView];
    [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(10);
      make.right.mas_equalTo(-10);
      make.top.mas_equalTo(weakSelf.headImageView.mas_bottom).offset(10);
      make.height.mas_equalTo(120);
    }];

  }
  
  return self;
}

- (void)mask:(HYBNetGridModel *)model {
  // 纯属是为了统一放在同一个测试功能下，所以没有放在初始化里添加
  static BOOL added = NO;
  if (!added) {
    CGFloat w  = [UIScreen mainScreen].bounds.size.width;
    
    [self.mainImageView hyb_addCorner:UIRectCornerAllCorners cornerRadius:10 size:CGSizeMake(w - 20, w - 20)];
    [self.headImageView hyb_addCorner:UIRectCornerAllCorners cornerRadius:50 size:CGSizeMake(100, 100)];
    added = YES;
  }
  
  UIImage *placeholder = [UIImage imageWithContentsOfFile:@"bimg5.jpg"];
  [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.mainImageUrl] placeholderImage:placeholder];
  
  [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"img5"]];
}

- (void)loadLocalImage:(HYBNetGridModel *)model {
  AppDelegate *delegate = [UIApplication sharedApplication].delegate;
  dispatch_queue_t queue = delegate.clipImageQueue;
  
  dispatch_async(queue , ^{
    if (![self.mainUrl isEqualToString:model.mainImageUrl]) {
      NSLog(@"不用开始处理了，已被复用了！");
      return;
    }
    
    UIImage *cacheImage = [HYBImageClipedManager clipedImageFromDiskWithKey:model.mainImageUrl];
    UIImage *tmpImage = [cacheImage hyb_clipToSize:CGSizeMake(self.bounds.size.width - 20, self.bounds.size.width - 20) cornerRadius:20 backgroundColor:[UIColor whiteColor] isEqualScale:NO];
    
    UIImage *cacheImage1 = [HYBImageClipedManager clipedImageFromDiskWithKey:model.headImageUrl];
    UIImage *tmpImage1 = [cacheImage1 hyb_clipCircleToSize:CGSizeMake(100, 100) backgroundColor:[UIColor whiteColor] isEqualScale:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([self.mainUrl isEqualToString:model.mainImageUrl]) {
        self.mainImageView.image = tmpImage;
        self.headImageView.image = tmpImage1;
      } else {
        NSLog(@"已被复用，不需要再赋值");
      }
      
    });
  });
}

- (void)configCellWithModel:(HYBNetGridModel *)model {
  self.mainUrl = model.mainImageUrl;
  self.headUrl = model.headImageUrl;
  self.locationLabel.text = model.location;
  self.userNameLabel.text = model.userName;
  self.adScrollView.imageUrls = model.adImageUrls;
  
  // 方式一:
  // 直接加载缓存的图片，每次都裁剪，这种方式为什么比 方式二要平滑多得
  // 基本没有感觉到卡。FPS平均在58~60之间
  // 内存在15M以内
//    [self loadLocalImage:model];
  
// 方式二：
  // 先尝试加载内存中的，若找不到则尝试读取文件，如果还找不到再去请求网络
  // FPS可平均在56~60之间，但是比方式一会有更明显卡
  // 内存在23M左右
    [self loadDataMethod2:model];
  
  // 方式三：
  // 没有感觉到卡，但是FPS低了些，在53~59之间
  // 内存在13M以内
//  [self beforeOptimize:model];
  
  // 方式四：
  // 不裁剪图片，通过mask来设置圆角
  // 内存在16M以内，FPS平均在50~58之间
  // 基本感觉不到卡
//  [self mask:model];
}

- (void)beforeOptimize:(HYBNetGridModel *)model {
  self.mainImageView.layer.cornerRadius = 10;
  self.mainImageView.clipsToBounds = YES;
  self.headImageView.layer.cornerRadius = 50;
  self.headImageView.clipsToBounds = YES;
  
  UIImage *placeholder = [UIImage imageWithContentsOfFile:@"bimg5.jpg"];
  [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.mainImageUrl] placeholderImage:placeholder];
  
  [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"img5"]];
}

- (void)loadDataMethod2:(HYBNetGridModel *)model {
  AppDelegate *delegate = [UIApplication sharedApplication].delegate;
  dispatch_queue_t queue = delegate.clipImageQueue;
  
  
  __weak __typeof(self) weakSelf = self;
  
  
  // 放到NSCache中可以提高访问效率，但是内存会增长很快
  UIImage *mainImage = [delegate.memoryCache objectForKey:[HYBNetGridCell hyb_md5:model.mainImageUrl]];
  if (mainImage != nil) {
    self.mainImageView.image = mainImage;
  } else {
    dispatch_async(queue, ^{
      UIImage *placeholder = [UIImage imageWithContentsOfFile:@"bimg5.jpg"];
      if (self.mainImageView.image == nil) {
        self.mainImageView.image = placeholder;
      }
      
      // 频繁读取文件会造成卡顿
      UIImage *mainImage = [HYBImageClipedManager clipedImageFromDiskWithKey:model.mainImageUrl];
      dispatch_async(dispatch_get_main_queue(), ^{
        if (mainImage) {
          if (self.mainUrl == model.mainImageUrl) {
            self.mainImageView.image = mainImage;
          } else {
            NSLog(@"被复用了，再赋值是没有意义的");
          }
          
          return;
        }
        
        [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.mainImageUrl] placeholderImage:nil options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
          if (image == nil || error != nil) {
            return;
          }
          
          dispatch_async(queue, ^{
            UIImage *tmpImage = [image hyb_clipToSize:weakSelf.mainImageView.hyb_size cornerRadius:10 backgroundColor:[UIColor whiteColor] isEqualScale:NO];
            [HYBImageClipedManager storeClipedImage:tmpImage toDiskWithKey:model.mainImageUrl];
            [delegate.memoryCache setObject:tmpImage forKey:[HYBNetGridCell hyb_md5:model.mainImageUrl]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
              if (model.mainImageUrl == self.mainUrl) {
                self.mainImageView.image = tmpImage;
              } else {
                NSLog(@"头像被复用");
              }
            });
          });
        }];
      });
    });
  }
  
  UIImage *headImage = [delegate.memoryCache objectForKey:[HYBNetGridCell hyb_md5:model.headImageUrl]];
  if (headImage) {
    self.headImageView.image = headImage;
  } else {
    dispatch_async(queue, ^{
      UIImage *placeholder = [UIImage imageWithContentsOfFile:@"img5.jpg"];
      if (self.headImageView.image == nil) {
        self.headImageView.image = placeholder;
      }
      
      UIImage *headImage = [HYBImageClipedManager clipedImageFromDiskWithKey:model.headImageUrl];
      dispatch_async(dispatch_get_main_queue(), ^{
        if (headImage) {
          if (self.headUrl == model.headImageUrl) {
            self.headImageView.image = headImage;
          } else {
            NSLog(@"被复用了，再赋值是没有意义的");
          }
          
          return;
        }
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:nil options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
          if (image == nil || error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            return;
          }
          dispatch_async(queue, ^{
            UIImage *tmpImage = [image hyb_clipCircleToSize:CGSizeMake(100, 100) backgroundColor:[UIColor whiteColor] isEqualScale:YES];
            [HYBImageClipedManager storeClipedImage:tmpImage toDiskWithKey:model.headImageUrl];
            [delegate.memoryCache setObject:tmpImage forKey:[HYBNetGridCell hyb_md5:model.headImageUrl]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
              if (model.mainImageUrl == self.mainUrl) {
                self.headImageView.image = tmpImage;
              } else {
                NSLog(@"头像被复用");
              }
            });
          });
        }];
      });
    });
  }
}


+ (NSString *)hyb_md5:(NSString *)string {
  if (string == nil || [string length] == 0) {
    return nil;
  }
  
  unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
  CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
  NSMutableString *ms = [NSMutableString string];
  
  for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [ms appendFormat:@"%02x", (int)(digest[i])];
  }
  
  return [ms copy];
}
@end
