//
//  ZZCarouselView.h
//  ZZCarouselView
//
//  Created by Roc on 2017/7/7.
//  Copyright © 2017年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZCarouselView;

@protocol ZZCarouselViewDelegate <NSObject>

/**
 * 图片点击监听
 */
- (void)carouselView:(ZZCarouselView *)carouselView clickImage:(UIImage *)image index:(NSInteger)index;

@end

@interface ZZCarouselView : UIView

/**
 * 初始化方法
 */
+ (instancetype)carouselWithImages:(NSArray *)images;
- (instancetype)initWithImages:(NSArray *)images;

/**
 * 代理属性
 */
@property (nonatomic, weak) id<ZZCarouselViewDelegate> delegate;

/**
 * 轮播时间间隔
 */
@property (nonatomic, assign) NSTimeInterval carouselTimeInterval;


@end

