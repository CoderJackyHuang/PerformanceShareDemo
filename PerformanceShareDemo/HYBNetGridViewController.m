//
//  HYBGridViewController.m
//  CollectionViewDemos
//
//  Created by huangyibiao on 16/3/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBNetGridViewController.h"
#import "HYBNetGridCell.h"
#import "HYBNetGridModel.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

static NSString *cellIdentifier = @"gridcellidentifier";

@interface HYBNetGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) BOOL isDouble;

@end

@implementation HYBNetGridViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = CGSizeMake(kScreenWidth, 10 + kScreenWidth - 20 + 20 + 20 + 10 + 100 + 10 + 120);
  layout.minimumLineSpacing = 10;
  layout.minimumInteritemSpacing = 10;
  layout.sectionInset = UIEdgeInsetsMake(0, 0, 74, 0);
  
  self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                           collectionViewLayout:layout];
  [self.view addSubview:self.collectionView];
  [self.collectionView registerClass:[HYBNetGridCell class]
          forCellWithReuseIdentifier:cellIdentifier];
  self.collectionView.delegate = self;
  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.collectionView.dataSource = self;

  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"改变布局"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(onChange)];
  [self prepareDatas];
}

- (void)onChange {
 UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  self.isDouble = !self.isDouble;
  
  if (self.isDouble) {
    layout.itemSize = CGSizeMake(kScreenWidth / 2 - 10, 10 + kScreenWidth / 2 - 10 - 20 + 20 + 20 + 10 + 100 + 10 + 120);

  } else {
    layout.itemSize = layout.itemSize = CGSizeMake(kScreenWidth, 10 + kScreenWidth - 20 + 20 + 20 + 10 + 100 + 10 + 120);
  }
}

- (void)prepareDatas {
  [self.datasource removeAllObjects];
  
  NSArray *mainUrls = @[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1459585554&di=523ca8368ebff3c1207eebbf9a6e0130&src=http://pic9.nipic.com/20100909/5708342_175057024268_2.jpg",
                        @"http://img2.3lian.com/2014/f5/171/d/32.jpg",
                        @"http://img2.3lian.com/2014/f5/171/d/36.jpg",
                        @"http://pic39.nipic.com/20140321/9448607_213919680000_2.jpg",
                        @"http://pic24.nipic.com/20121008/564740_165859681383_2.jpg",
                        @"http://pic31.nipic.com/20130718/13159918_161225362000_2.jpg",
                        @"http://img3.3lian.com/2013/s1/20/d/57.jpg",
                        @"http://pic41.nipic.com/20140520/18505720_144032556135_2.jpg",
                        @"http://img1.3lian.com/2015/w7/98/d/21.jpg",
                        @"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg",
                        @"http://pic41.nipic.com/20140515/2383657_184117540152_2.jpg",
                        @"http://pic.nipic.com/2008-05-05/200855101624904_2.jpg",
                        @"http://pic.nipic.com/2008-02-19/2008219192427676_2.jpg",
                        @"http://pic.nipic.com/2008-05-14/200851492938649_2.jpg"];
  NSArray *headImageUrls = @[@"http://img2.3lian.com/2014/f5/171/d/37.jpg",
                             @"http://img1.3lian.com/2015/w7/98/d/25.jpg",
                             @"http://image73.360doc.com/DownloadImg/2014/05/2813/42104722_11.jpg",
                             @"http://img1.3lian.com/2015/w7/98/d/23.jpg",
                             @"http://pic13.nipic.com/20110407/4711921_154320871000_2.jpg",
                             @"http://pic9.nipic.com/20100822/1954049_115030098195_2.jpg",
                             @"http://pic.nipic.com/2008-07-16/2008716174548321_2.jpg",
                             @"http://pic3.nipic.com/20090630/2827329_134929002_2.jpg",
                             @"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg",
                             @"http://pic.nipic.com/2007-12-15/20071215123216861_2.jpg",
                             @"http://pic4.nipic.com/20090730/2854555_154713079_2.jpg",
                             @"http://pic41.nipic.com/20140524/18849442_210536184142_2.jpg",
                             @"http://pic16.nipic.com/20110829/3441550_100152357000_2.jpg"];
  NSArray *adImages = @[@"http://pic39.nipic.com/20140325/6947145_150220631172_2.jpg",
                        @"http://pic41.nipic.com/20140519/18505720_091902163180_2.jpg",
                        @"http://pic41.nipic.com/20140518/18505720_150033499137_2.jpg",
                        @"http://pic5.nipic.com/20091222/3822085_091248555125_2.jpg",
                        @"http://pic.nipic.com/2007-11-16/2007111617030429_2.jpg",
                        @"http://pic1.nipic.com/2008-11-24/20081124174630578_2.jpg",
                        @"http://pic.nipic.com/2008-01-06/200816234433475_2.jpg"];
    int j = 0;
    
    for (NSUInteger i = 0; i < 100; ++i) {
      if (j >= mainUrls.count || j >= headImageUrls.count) {
        j = 0;
      }
      
      HYBNetGridModel *model = [[HYBNetGridModel alloc] init];
      model.mainImageUrl = [mainUrls objectAtIndex:j];
      model.location = [NSString stringWithFormat:@"某城市某地点，大图第%ld项 坐标(139, 119)", i];
      model.headImageUrl = [headImageUrls objectAtIndex:j];
      model.userName = @"技术部：iOS-黄仪标";
      
      model.adImageUrls = adImages;
      
      [self.datasource addObject:model];
      j++;
    }
  
  [self.collectionView reloadData];
}

- (NSMutableArray *)datasource {
  if (_datasource == nil) {
    _datasource = [[NSMutableArray alloc] init];
  }
  
  return _datasource;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  HYBNetGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                forIndexPath:indexPath];
    HYBNetGridModel *model = self.datasource[indexPath.item];
  model.currentItem = indexPath.item;
    [(HYBNetGridCell *)cell configCellWithModel:model];
  
  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.datasource.count;
}

@end
