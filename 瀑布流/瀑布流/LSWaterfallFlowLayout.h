//
//  LSWaterfallFlowLayout.h
//  瀑布流
//
//  Created by 焦林生 on 2017/2/18.
//  Copyright © 2017年 jiaolinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSWaterfallFlowLayout;

@protocol LSWaterfallFlowLayoutDelegate <NSObject>

@required
/**
 *  返回indexPath位置cell的高度
 */
- (CGFloat)waterfallFlowLayout:(LSWaterfallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWith:(CGFloat)width;

@optional

/**
 *  返回布局的行间距
 */
- (CGFloat)rowSpacingInWaterfallFlowLayout:(LSWaterfallFlowLayout *)layout;

/**
 *  返回布局的列间距
 */
- (CGFloat)columnSpacingInWaterfallFlowLayout:(LSWaterfallFlowLayout *)layout;

/**
 *  返回布局的边距
 */
- (UIEdgeInsets)edgeInsetsInWaterfallFlowLayout:(LSWaterfallFlowLayout *)layout;

/**
 *  返回布局的列数
 */
- (NSUInteger)columnCountInWaterfallFlowLayout:(LSWaterfallFlowLayout *)layout;

@end

@interface LSWaterfallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<LSWaterfallFlowLayoutDelegate>delegate;

@end
