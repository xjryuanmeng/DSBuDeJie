//
//  XJRSquareCell.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/20.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRSquareCell.h"
#import <UIImageView+WebCache.h>
#import "XJRSquareItem.h"

@interface XJRSquareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end
@implementation XJRSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setItem:(XJRSquareItem *)item
{
    _item = item;
    
    // 给子控件赋值
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    _nameView.text = item.name;
    
}
@end
