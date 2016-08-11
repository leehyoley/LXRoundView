//
//  JARoundCell.h
//  JiangAi
//
//  Created by XiaoleiLi on 16/2/22.
//  Copyright © 2016年 jiangai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LXRoundStyle_Circle,
    LXRoundStyle_Heart
}LXRoundStyle;
@interface JARoundCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *holderName;
-(void)makeStyle:(LXRoundStyle)style Corner:(CGFloat)roundCorner;
@end
