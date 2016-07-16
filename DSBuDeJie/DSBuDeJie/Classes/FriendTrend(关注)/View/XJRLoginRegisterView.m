//
//  XJRLoginRegisterView.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRLoginRegisterView.h"

@interface XJRLoginRegisterView ()

@property (weak, nonatomic) IBOutlet UIButton *loginRegisterBtn;

@end

@implementation XJRLoginRegisterView

+ (instancetype)loginView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"XJRLoginRegisterView" owner:nil options:nil]firstObject];
    
}
+ (instancetype)registerView{
     return [[[NSBundle mainBundle]loadNibNamed:@"XJRLoginRegisterView" owner:nil options:nil]lastObject];
}

// 从xib加载就会调用,就会把xib所有的属性全部设置
-(void)awakeFromNib{
    UIImage *image = self.loginRegisterBtn.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [self.loginRegisterBtn setBackgroundImage:image forState:UIControlStateNormal];
}
@end
