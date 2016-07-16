//
//  XJRSubTagCell.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRSubTagCell.h"
#import <UIImageView+WebCache.h>
#import "XJRSubTagItem.h"
#import "UIImage+XJRRender.h"

@interface XJRSubTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;

@end
/*
 界面细节:
 1.头像 圆 1.修改控件的圆角半径 2.裁剪图片生成一张新的圆角图片-->图形上下文
 2.数字
 */

/*
 ios9之后,帧数就不会下降,苹果修复了这个问题
 ios9之前,还是有问题
 */

@implementation XJRSubTagCell
//调用set方法
-(void)setItem:(XJRSubTagItem *)item{
    _item = item;
    //头像
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //圆形头像(第二种方法)-->裁剪图片:图形上下文(步骤)
        /*
         //1.开启图形上下文
         // scale:比例因素 点:像素比例 0:自动识别比例因素
         UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
         //2.描述圆形裁剪路径
         UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
         //3.设置为裁剪区域
         [clipPath addClip];
         //4.画图片
         [image drawAtPoint:CGPointZero];
         //5.取出图片
         image = UIGraphicsGetImageFromCurrentImageContext();
         //6.关闭上下文
         UIGraphicsEndImageContext();
         self.iconView.image = image;
         */
        //抽分类
        self.iconView.image = [image circleImage];
    }];
    //姓名
    _nameView.text = item.theme_name;
    //订阅数量
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅",item.sub_number];
    NSInteger num = numStr.intValue;
    if (num > 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅",numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    _numView.text = numStr;
}
//从xib加载就会调用,只会调用一次
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //修改控件圆角,使头像成为圆形(第一种方法)
    //self.iconView.layer.cornerRadius = self.iconView.xjr_width * 0.5;
    //超出主层边框的就会被裁剪掉
    //self.iconView.layer.masksToBounds = YES;
    // Initialization code
}

-(void)setFrame:(CGRect)frame{
    
    frame.size.height -= 2;
    //给cellframe赋值
    [super setFrame:frame];
    
}
@end
