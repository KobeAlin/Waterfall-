//
//  LSWaterfallFlowLayout.m
//  瀑布流
//
//  Created by 焦林生 on 2017/2/18.
//  Copyright © 2017年 jiaolinsheng. All rights reserved.
//

#import "LSWaterfallFlowLayout.h"
#define LSCollectionViewWidth self.collectionView.frame.size.width

//默认行间距
static const CGFloat LSDefaultRowSpacing = 10;
//默认列间距
static const CGFloat LSDefaultColumnSpacing = 20;
//默认边距
static const UIEdgeInsets LSDefaultEdgeInsets = {10,10,10,10};
//默认列说
static const NSUInteger LSDefaultColumnCount = 3;

@interface LSWaterfallFlowLayout ()

//每一列的最大 Y 坐标
@property (nonatomic, strong) NSMutableArray *columnMaxYArray;
//存放所有 cell 的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;

//声明 get 方法
- (CGFloat)rowSpacing;
- (CGFloat)columnSpacing;
- (UIEdgeInsets)edgeInsets;
- (NSUInteger)columnCount;

@end

@implementation LSWaterfallFlowLayout

#pragma mark --懒加载
- (NSMutableArray *)columnMaxYArray
{
    if (!_columnMaxYArray) {
        _columnMaxYArray = [NSMutableArray array];
    }
    return _columnMaxYArray;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark -- 实现内部方法

//决定 CollectionView的 ContentSize
- (CGSize)collectionViewContentSize
{

    //找出最长那一列的最大 Y 值
    CGFloat destColumnMaxY = [self.columnMaxYArray[0] doubleValue];
    
    for (int i = 0; i < self.columnMaxYArray.count; i ++) {
        
        CGFloat columnMaxY = [self.columnMaxYArray[i] doubleValue];
        
        if (columnMaxY > destColumnMaxY) {
            
            destColumnMaxY = columnMaxY;
        }
    }
    return CGSizeMake(LSCollectionViewWidth, destColumnMaxY + self.edgeInsets.bottom);
}

//调用一次 (重新刷新布局调用)
- (void)prepareLayout
{
    [super prepareLayout];
    
    //重置每一列的最大的 Y 坐标
    [self.columnMaxYArray removeAllObjects];
    
    for (int i = 0; i < self.columnCount; i ++) {
        
        [self.columnMaxYArray addObject:@(0)];
    }
    
    //计算所有 cell 的布局属性
    [self.attrsArray removeAllObjects];
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
    }
}

//collectionview 所有的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layoutAttributesForElementsInRect");
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < self.attrsArray.count; i ++) {
        
        UICollectionViewLayoutAttributes *attrs = self.attrsArray[i];
        if (CGRectIntersectsRect(rect, attrs.frame)) {//优化性能
            
            [array addObject:attrs];
        }
    }
    
    return array;
}

// indexpath 位置 cell 的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //计算 indexpath 位置 cell 的布局属性
    //找出最短那一列的列号和最大的 Y 坐标
    //核心代码
    CGFloat destColumnMaxY = [self.columnMaxYArray[0] doubleValue];
    
    NSInteger destColumnIndex = 0;
    
    for (int i = 0; i < self.columnMaxYArray.count; i ++) {
        
        CGFloat columnMaxY = [self.columnMaxYArray[i] doubleValue];
        
        if (columnMaxY < destColumnMaxY) {
            
            destColumnMaxY = columnMaxY;
            destColumnIndex = i;
        }
    }
    
    //attr的 frame
    CGFloat totalColumnSpacing = (self.columnCount - 1)*self.columnSpacing;
    
    CGFloat width = (LSCollectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - totalColumnSpacing)/self.columnCount;

    CGFloat height = [self.delegate waterfallFlowLayout:self heightForItemAtIndexPath:indexPath withItemWith:width];
    
    CGFloat x = self.edgeInsets.left + destColumnIndex * (width + self.columnSpacing);
    CGFloat y = destColumnMaxY;
    
    if (destColumnMaxY != self.edgeInsets.top) {
        y += self.rowSpacing;
    }
    attrs.frame = CGRectMake(x, y, width, height);
    
    //更新最大Y 坐标
    self.columnMaxYArray[destColumnIndex] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}

#pragma mark 响应代理方法
- (CGFloat)rowSpacing
{
    if ([self respondsToSelector:@selector(rowSpacingInWaterfallFlowLayout:)]) {
        return [self.delegate rowSpacingInWaterfallFlowLayout:self];
    }
    return LSDefaultRowSpacing;
}

- (CGFloat)columnSpacing
{
    if ([self respondsToSelector:@selector(columnSpacingInWaterfallFlowLayout:)]) {
        return [self.delegate columnSpacingInWaterfallFlowLayout:self];
    }
    return LSDefaultColumnSpacing;
}

- (UIEdgeInsets)edgeInsets
{
    if ([self respondsToSelector:@selector(edgeInsetsInWaterfallFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterfallFlowLayout:self];
    }
    return LSDefaultEdgeInsets;
}

- (NSUInteger)columnCount
{
    if ([self respondsToSelector:@selector(columnCountInWaterfallFlowLayout:)]) {
        return [self.delegate columnCountInWaterfallFlowLayout:self];
    }
    return LSDefaultColumnCount;
}


@end
