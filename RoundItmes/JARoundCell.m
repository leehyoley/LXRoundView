//
//  JARoundCell.m
//  JiangAi
//
//  Created by XiaoleiLi on 16/2/22.
//  Copyright © 2016年 jiangai. All rights reserved.
//

#import "JARoundCell.h"
#import "UIImageView+WebCache.h"
@implementation JARoundCell

- (void)awakeFromNib {
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    UIImage *holder = [UIImage imageNamed:_imageName];
    if (!holder) {
        if (_holderName) {
            holder = [UIImage imageNamed:_holderName];
        }
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:holder];
}


-(void)makeStyle:(LXRoundStyle)style Corner:(CGFloat)roundCorner{
    //阴影，影响性能
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOpacity = 1.0f;
    self.layer.masksToBounds = NO;
    
    switch (style) {
        case LXRoundStyle_Circle:
        {
            self.contentView.layer.cornerRadius = roundCorner;
            self.contentView.layer.masksToBounds = YES;
            self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:roundCorner].CGPath;
        }
            break;
            
        case LXRoundStyle_Heart:{
            UIBezierPath *maskPath = [[UIBezierPath alloc] init];
            [maskPath moveToPoint:CGPointMake(roundCorner, roundCorner*2/4.0)];
            //右半心
            [maskPath addCurveToPoint:CGPointMake(roundCorner, roundCorner*2) controlPoint1:CGPointMake(roundCorner*1.75, -0.5*roundCorner) controlPoint2:CGPointMake(roundCorner*2.5, roundCorner*1.25)];
            
            //左半心
            [maskPath addCurveToPoint:CGPointMake(roundCorner, roundCorner*2/4.0) controlPoint1:CGPointMake(-0.5*roundCorner, roundCorner*1.25)controlPoint2:CGPointMake(roundCorner*0.25, -0.5*roundCorner)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.contentView.layer.mask = maskLayer;
            self.layer.shadowPath = maskPath.CGPath;
        
        }
            break;
    }
}

@end
