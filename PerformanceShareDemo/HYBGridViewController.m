//
//  HYBGridViewController.m
//  CollectionViewDemos
//
//  Created by huangyibiao on 16/3/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBGridViewController.h"
#import "HYBGridCell.h"
#import "HYBGridModel.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

static NSString *cellIdentifier = @"gridcellidentifier";

@interface HYBGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) BOOL isBig;

@end

@implementation HYBGridViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = CGSizeMake((kScreenWidth - 30) / 2, (kScreenWidth - 30) / 2 + 20 + 100);
  layout.minimumLineSpacing = 10;
  layout.minimumInteritemSpacing = 10;
  layout.sectionInset = UIEdgeInsetsMake(20, 0, 84, 0);
  
  self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                           collectionViewLayout:layout];
  [self.view addSubview:self.collectionView];
  [self.collectionView registerClass:[HYBGridCell class]
          forCellWithReuseIdentifier:cellIdentifier];
  self.collectionView.delegate = self;
  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.collectionView.dataSource = self;
  
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                         action:@selector(onChange)];
  self.isBig = YES;
  [self onChange];
}

- (void)onChange {
  self.isBig = !self.isBig;
  [self.datasource removeAllObjects];
  
  if (self.isBig) {
    int j = 0;
    
    for (NSUInteger i = 0; i < 100; ++i) {
      if (++j > 14) {
        j = 1;
      }
      
      HYBGridModel *model = [[HYBGridModel alloc] init];
      model.imageName = [NSString stringWithFormat:@"bimg%d.%@",
                         j, @"jpg"];
      if (i % 2 == 0) {
        model.title = [NSString stringWithFormat:@"大图第%ld项", i];
      } else {
        model.title = [NSString stringWithFormat:@"Big Item %ld", i];
      }
      
      model.userName = @"技术部：iOS-黄仪标";
      
      model.headImageName = model.imageName;
      
      [self.datasource addObject:model];
    }
  } else {
    int j = 0;
    
    for (NSUInteger i = 0; i < 100; ++i) {
      if (++j > 12) {
        j = 1;
      }
      
      HYBGridModel *model = [[HYBGridModel alloc] init];
      model.imageName = [NSString stringWithFormat:@"img%d.%@",
                         j,
                         j == 1 || j == 2 || j == 3 ? @"jpeg" : @"jpg"];
      if (i % 2 == 0) {
        model.title = [NSString stringWithFormat:@"第%ld项", i];
      } else {
        model.title = [NSString stringWithFormat:@"Item %ld", i];
      }
      
      model.userName = @"技术部：iOS-黄仪标";
      
      model.headImageName = model.imageName;
      
      [self.datasource addObject:model];
    }
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
  HYBGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                         forIndexPath:indexPath];
  HYBGridModel *model = self.datasource[indexPath.item];
  [cell configCellWithModel:model];
  
  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.datasource.count;
}

@end
