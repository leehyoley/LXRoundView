//
//  LXRoundLayout.m
//  RoundItmes
//
//  Created by XiaoleiLi on 16/8/5.
//  Copyright © 2016年 leehyoley. All rights reserved.
//

#import "LXRoundLayout.h"

//最小的大小比例
#define MIN_SCALE  0.55

@implementation LXRoundLayout
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    CGFloat itemWH = self.collectionView.frame.size.height;
    self.itemSize = CGSizeMake(itemWH, itemWH);
    
    CGFloat inset = (self.collectionView.frame.size.width - itemWH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.minimumLineSpacing = -self.collectionView.frame.size.width/6.7;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    static NSInteger currentItem = 0;
    for (int i = 0; i< array.count; i++) {
        
        UICollectionViewLayoutAttributes *attrs = array[i];
        
        CGFloat delta = ABS(centerX - attrs.center.x);
        CGFloat t = delta/(self.collectionView.frame.size.width/2);
        CGFloat scale =  MIN_SCALE + (1-MIN_SCALE)*(1-t);
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
        //弧形排列
        //        attrs.center = CGPointMake(attrs.center.x,self.collectionView.height*0.3+self.collectionView.height*0.45*(1-t*t));
        
        if (delta<10&&currentItem!=attrs.indexPath.item) {
            currentItem = attrs.indexPath.item;
            if (self.didScrollAt) {
                self.didScrollAt(attrs.indexPath.item);
            }
        }
    }
    
    for (int i = 0; i< array.count; i++) {
        
        UICollectionViewLayoutAttributes *attrs = array[i];
        //设置层叠状态，中间的zIndex为0，越远的越小，越靠后
        attrs.zIndex =-1*ABS(attrs.indexPath.item - currentItem);
    }
    
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDetal = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDetal) > ABS(attrs.center.x - centerX)) {
            minDetal = attrs.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
}

@end
