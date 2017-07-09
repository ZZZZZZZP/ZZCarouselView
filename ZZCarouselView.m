//
//  ZZCarouselView.m
//  ZZCarouselView
//
//  Created by Roc on 2017/7/7.
//  Copyright © 2017年 zp. All rights reserved.
//

#import "ZZCarouselView.h"

#define kZZImageCell @"kZZImageCell"

@interface ZZCarouselView ()
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, weak) UICollectionViewFlowLayout *layout;
@property (nonatomic, weak) UICollectionView *imgCollection;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZZCarouselView

//MARK: - 初始化图片
- (void)setImages:(NSArray *)images
{
    id img = images[0];
    
    if ([img isKindOfClass:[NSString class]]) {
        
        NSMutableArray *imgArr = [NSMutableArray array];
        for (NSString *name in images) {
            [imgArr addObject:[UIImage imageNamed:name]];
        }
        _images = [NSArray arrayWithArray:imgArr];
    }
    
    else if ([img isKindOfClass:[UIImage class]]) {
        _images = images;
    }
}

//MARK: - 初始化方法
+ (instancetype)carouselWithImages:(NSArray *)images
{
    return [[ZZCarouselView alloc] initWithImages:images];
}

- (instancetype)initWithImages:(NSArray *)images
{
    if (self = [super init]) {
        self.carouselTimeInterval = 2;
        self.images = images;
        [self setupUI];
    }
    return self;
}

//MARK: - 设置控件
- (void)setupUI
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    _layout = layout;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *imgCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _imgCollection = imgCollection;
    [self addSubview:imgCollection];
    imgCollection.dataSource = self;
    imgCollection.delegate = self;
    imgCollection.pagingEnabled = YES;
    imgCollection.showsHorizontalScrollIndicator = NO;
    [imgCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kZZImageCell];
    
}

//MARK: - 布局控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imgCollection.frame = self.bounds;
    _layout.itemSize = _imgCollection.bounds.size;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_images.count * 50 inSection:0];
    [_imgCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}

//MARK: - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count * 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZZImageCell forIndexPath:indexPath];
    
    UIImage *image = _images[indexPath.item % _images.count];
    cell.layer.contents = (id)image.CGImage;
    
    return cell;
}

//MARK: - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeCarouselTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addCarouselTimer];
    
    if (!decelerate) {
        [self carouselViewReset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self carouselViewReset];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self carouselViewReset];
}

//MARK: - 轮播复位
- (void)carouselViewReset
{
    CGFloat offsetX = _imgCollection.contentOffset.x;
    CGFloat itemW   = _layout.itemSize.width;
    
    NSInteger itemIndex = (NSInteger)(offsetX / itemW) % _images.count;
    
    if (offsetX >= _images.count * 90 * itemW||
        offsetX <= _images.count * 10 * itemW) {
        
        offsetX = (_images.count * 50 + itemIndex) * itemW;
        _imgCollection.contentOffset = CGPointMake(offsetX, 0);
    }
}

//MARK: - 图片点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(carouselView: clickImage: index:)]) {
        
        NSInteger index = indexPath.item % _images.count;
        [self.delegate carouselView:self clickImage:_images[index] index:index];
    }
}

//MARK: - 操作定时器
- (void)addCarouselTimer
{
    _timer = [NSTimer timerWithTimeInterval:self.carouselTimeInterval target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeCarouselTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollToNext
{
    CGFloat offsetX = _imgCollection.contentOffset.x + _layout.itemSize.width;
    [_imgCollection setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

//MARK: - 设置轮播间隔时间
- (void)setCarouselTimeInterval:(NSTimeInterval)carouselTimeInterval
{
    _carouselTimeInterval = carouselTimeInterval;
    
    [self removeCarouselTimer];
    [self addCarouselTimer];
}


@end

