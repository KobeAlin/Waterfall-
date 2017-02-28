//
//  LSWaterfallViewController.m
//  瀑布流
//
//  Created by 焦林生 on 2017/2/18.
//  Copyright © 2017年 jiaolinsheng. All rights reserved.
//

#import "LSWaterfallViewController.h"
#import "LSWaterfallFlowLayout.h"
#import "LSWaterfallCell.h"
#import "LSWaterModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface LSWaterfallViewController ()<LSWaterfallFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation LSWaterfallViewController

static NSString * const reuseIdentifier = @"waterCell";

#pragma mark -- 懒加载
- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请求数据
    NSArray *tempArray = [LSWaterModel objectArrayWithFilename:@"clothes.plist"];
    [self.modelArray addObjectsFromArray:tempArray];
    
    //切换布局
    LSWaterfallFlowLayout *layout = [[LSWaterfallFlowLayout alloc] init];
    layout.delegate = self;
    self.collectionView.collectionViewLayout = layout;
    
    __weak typeof(self) weakSelf = self;
    
    //刷新数据
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //加载数据
        NSArray *tempArray = [LSWaterModel objectArrayWithFilename:@"clothes.plist"];
        [weakSelf.modelArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArray.count)]];
        [weakSelf.collectionView reloadData];
        
        //结束刷新
        [weakSelf.collectionView.header endRefreshing];
    }];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        // 加载数据
        NSArray *tempArray = [LSWaterModel objectArrayWithFilename:@"clothes.plist"];
        [weakSelf.modelArray addObjectsFromArray:tempArray];
        [weakSelf.collectionView reloadData];
        
        // 结束刷新
        [weakSelf.collectionView.footer endRefreshing];
    }];
}

#pragma mark <LSWaterfallFlowLayoutDelegate>
- (CGFloat)waterfallFlowLayout:(LSWaterfallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWith:(CGFloat)width
{

    LSWaterModel *model = self.modelArray[indexPath.item];
    
    return model.h * width / model.w;
}

- (NSUInteger)columnCountInWaterfallFlowLayout:(LSWaterfallFlowLayout *)layout {
    return 3;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSWaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.waters = self.modelArray[indexPath.item];
    
    return cell;
}




@end
