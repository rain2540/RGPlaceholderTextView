//
//  RGPlaceholderTextView.h
//  RGPlaceholderTextView
//
//  Created by Rain on 2018/8/15.
//  Copyright © 2018年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RGPlaceholderTextView : UITextView

/**
 占位文字
 */
@property (nonatomic, copy) IBInspectable NSString *placeholder;
/**
 占位文字颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
/**
 占位文字字体
 */
@property (nonatomic, strong) UIFont *placeholderFont;

//@property (nonatomic, assign) NSInteger inputLimit;

@end
