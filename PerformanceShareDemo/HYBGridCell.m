//
//  HYBGridCell.m
//  CollectionViewDemos
//
//  Created by huangyibiao on 16/3/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBGridCell.h"
#import "HYBGridModel.h"
#import <HYBImageCliped.h>

@interface HYBGridCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *userNameLabel;

@end

@implementation HYBGridCell

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0, self.imageView.frame.size.height, self.frame.size.width, 20);
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
//    self.titleLabel.backgroundColor = [UIColor blackColor];
//    self.titleLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.titleLabel];
    
    self.headView = [[UIImageView alloc] init];
    self.headView.frame = CGRectMake(10, self.titleLabel.frame.origin.y + 20 + 10, 60, 60);
//    self.headView.layer.cornerRadius = 30;
//    self.headView.clipsToBounds = YES;
    [self.contentView addSubview:self.headView];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.frame = CGRectMake(10, self.headView.frame.origin.y + 60 + 10, self.frame.size.width - 20, 20);
    self.userNameLabel.numberOfLines = 2;
    self.userNameLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.userNameLabel];
    self.userNameLabel.textAlignment = NSTextAlignmentLeft;
    self.userNameLabel.textColor = [UIColor blackColor];
  }
  
  return self;
}

- (void)configCellWithModel:(HYBGridModel *)model {
  if (model.clipedImage) {
    self.imageView.image = model.clipedImage;
  } else {
    // 将剪裁过的记录到模型中，防止重复剪裁，可提高性能
    // 这里是异步去剪裁，所以不会阻塞
[self.imageView hyb_setImage:model.imageName isEqualScale:YES onCliped:^(UIImage *clipedImage) {
  model.clipedImage = clipedImage;
}];
  }
  
  if (model.clipedHeadImage) {
    self.headView.image = model.clipedHeadImage;
  } else {
//    [self.headView hyb_setImage:model.headImageName isEqualScale:YES onCliped:^(UIImage *clipedImage) {
//      model.clipedHeadImage = clipedImage;
//    }];
[self.headView hyb_setCircleImage:model.headImageName isEqualScale:YES onCliped:^(UIImage *clipedImage) {
  model.clipedHeadImage = clipedImage;
}];
  }
  
//  if (model.clipedImage) {
//    self.imageView.layer.contents = (__bridge id _Nullable)(model.clipedImage.CGImage);
//  } else {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//      UIImage *image = [UIImage imageNamed:model.imageName];
//      image = [self clipImage:image toSize:self.imageView.frame.size];
//      dispatch_async(dispatch_get_main_queue(), ^{
//        model.clipedImage = image;
//        self.imageView.layer.contents = (__bridge id _Nullable)(model.clipedImage.CGImage);
//      });
//    });
//  }
//  
//  if (model.clipedHeadImage) {
//       self.headView.layer.contents = (__bridge id _Nullable)(model.clipedHeadImage.CGImage);
//  } else {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//      UIImage *image = [UIImage imageNamed:model.imageName];
//      image = [self clipImage:image toSize:self.headView.frame.size isCircle:YES];
//      dispatch_async(dispatch_get_main_queue(), ^{
//        model.clipedHeadImage = image;
//        self.headView.layer.contents = (__bridge id _Nullable)(model.clipedHeadImage.CGImage);
//      });
//    });
//  }
  
  self.userNameLabel.text = model.userName;
  self.titleLabel.text = model.title;
}


- (UIImage *)clipImage:(UIImage *)image toSize:(CGSize)size {
  UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
  
  CGSize imgSize = image.size;
  CGFloat x = MAX(size.width / imgSize.width, size.height / imgSize.height);
  CGSize resultSize = CGSizeMake(x * imgSize.width, x * imgSize.height);
  
  [image drawInRect:CGRectMake(0, 0, resultSize.width, resultSize.height)];
  
  UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return finalImage;
}


- (UIImage *)clipImage:(UIImage *)image toSize:(CGSize)size isCircle:(BOOL)isCircle {
  UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
  
  CGSize imgSize = image.size;
  CGFloat x = MAX(size.width / imgSize.width, size.height / imgSize.height);
  CGSize resultSize = CGSizeMake(x * imgSize.width, x * imgSize.height);
  
 [[UIColor whiteColor] setFill];
  CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, resultSize.width, resultSize.height));

  if (isCircle) {
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:(CGRect){0, 0, resultSize.width, resultSize.height} cornerRadius:(MIN(resultSize.width, resultSize.height)) / 2].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
  }
  
  
[image drawInRect:CGRectMake(0, 0, resultSize.width, resultSize.height)];
  
  UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return finalImage;
}

@end
