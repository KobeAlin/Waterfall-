//
//  LSWaterfallCell.m
//  瀑布流
//
//  Created by 焦林生 on 2017/2/18.
//  Copyright © 2017年 jiaolinsheng. All rights reserved.
//

#import "LSWaterfallCell.h"
#import "LSWaterModel.h"
#import "UIImageView+WebCache.h"

@interface LSWaterfallCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation LSWaterfallCell

- (void)setWaters:(LSWaterModel *)waters
{
    _waters = waters;
    
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:waters.img] placeholderImage:[UIImage imageNamed:@"loading.png"]];
    
    //设置价格
    self.priceLabel.text = waters.price;
}


@end
