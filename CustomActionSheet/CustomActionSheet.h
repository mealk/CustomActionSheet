//
//  CustomActionSheet.h
//  CustomActionSheet
//
//  Created by Mealk.Lei on 15/7/21.
//  Copyright (c) 2015年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickedButtonAtIndexBlock)(NSInteger buttonIndex);

@interface CustomActionSheet : UIView

@property (nonatomic, strong) ClickedButtonAtIndexBlock clickedButtonAtIndex;
@property (nonatomic, strong) UIColor *cancelButtonTintColor;
@property (nonatomic, strong) UIColor *otherButtonTintColor;

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)setTitleColor:(UIColor *)titleColor atIndex:(NSInteger)index;
- (void)show;

@end
