//
//  CustomActionSheet.m
//  CustomActionSheet
//
//  Created by Mealk.Lei on 15/7/21.
//  Copyright (c) 2015年 developer. All rights reserved.
//

#import "CustomActionSheet.h"

#define H [UIScreen mainScreen].bounds.size.height
#define W [UIScreen mainScreen].bounds.size.width
#define ItemHeight 50.0f
#define Spacing 7.0f
#define kSubTitleHeight 65.0f

@interface CustomActionSheet ()<UIGestureRecognizerDelegate>

@property (nonatomic,copy) NSString *cancelButtonTitle;

@property (nonatomic,strong) NSMutableArray *otherButtonTitles;

@property (nonatomic,weak) UIView *sheetView;

@property (nonatomic,copy) NSString *titleStr;

@end

@implementation CustomActionSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    
    if (self) {
        
        _titleStr = title;
        _cancelButtonTitle = cancelButtonTitle;
        
        _otherButtonTitles = [NSMutableArray array];
        NSString *eachItem;
        va_list argumentList;
        if (otherButtonTitles)
        {
            [_otherButtonTitles addObject: otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while((eachItem = va_arg(argumentList, NSString *)))
            {
                [_otherButtonTitles addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        [self setSheetViewUI];
        
    }
    
    return self;
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (void)setTitleColor:(UIColor *)titleColor atIndex:(NSInteger)index{
    
    UIButton *btn = (UIButton *)[_sheetView viewWithTag:index + 100];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
}

- (void)setOtherButtonTintColor:(UIColor *)otherButtonTintColor
{
    for (int i =1 ; i <= _otherButtonTitles.count; i++) {
        UIButton *btn = (UIButton *)[_sheetView viewWithTag:i + 100];
        [btn setTitleColor:otherButtonTintColor forState:UIControlStateNormal];
    }
}

- (void)setCancelButtonTintColor:(UIColor *)cancelButtonTintColor
{
    UIButton *btn = (UIButton *)[_sheetView viewWithTag:100];
    [btn setTitleColor:cancelButtonTintColor forState:UIControlStateNormal];
    _cancelButtonTintColor = cancelButtonTintColor;
}

- (void)setSheetViewUI
{
    [self setFrame:CGRectMake(0, 0, W, H)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:226.0f/255.f blue:236.0f/255.0f alpha:1];
    CGFloat height;
    
    if (_titleStr.length > 0) {
        height  = ((ItemHeight+0.5f)+Spacing) + (_otherButtonTitles.count * (ItemHeight+0.5f)) + kSubTitleHeight;
    }else{
        
        height = ((ItemHeight+0.5f)+Spacing) + (_otherButtonTitles.count * (ItemHeight+0.5f));
    }
    
    view.frame = CGRectMake(0, H, W, height);
    [self addSubview:view];
    _sheetView = view;
    
    if (_titleStr.length > 0) {
        UILabel *AttachTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, kSubTitleHeight)];
        AttachTitleView.backgroundColor = [UIColor whiteColor];
        AttachTitleView.font = [UIFont systemFontOfSize:12.0f];
        AttachTitleView.textColor = [UIColor grayColor];
        AttachTitleView.text = _titleStr;
        AttachTitleView.textAlignment = 1;
        
        [_sheetView addSubview:AttachTitleView];
    }
    
    UIButton *Cancebtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [Cancebtn setBackgroundColor:[UIColor whiteColor]];
    [Cancebtn setFrame:CGRectMake(0, CGRectGetHeight(_sheetView.bounds) - ItemHeight, W, ItemHeight)];
    [Cancebtn setTitleColor:self.cancelButtonTintColor?:[UIColor blackColor] forState:UIControlStateNormal];
    [Cancebtn setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    [Cancebtn addTarget:self action:@selector(clickedButtons:) forControlEvents:UIControlEventTouchUpInside];
    [Cancebtn setTag:100];
    [_sheetView addSubview:Cancebtn];
    
    for (NSString *Title in _otherButtonTitles) {
        
        NSInteger index = [_otherButtonTitles indexOfObject:Title];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat hei = (50.5 * _otherButtonTitles.count)+Spacing;
        CGFloat y = (CGRectGetMinY(Cancebtn.frame) + (index * (ItemHeight+0.5))) - hei;
        
        [btn setFrame:CGRectMake(0, y, W, ItemHeight)];
        [btn setTag:(index + 100)+1];
        [btn setTitleColor:self.otherButtonTintColor?:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:Title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedButtons:) forControlEvents:UIControlEventTouchUpInside];
        [_sheetView addSubview:btn];
    }
    
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]];
        [_sheetView setFrame:CGRectMake(0, H - height, W, height+10)];
        
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weak action:@selector(tapDismiss:)];
        tap.delegate = self;
        [weak addGestureRecognizer:tap];
        
        [_sheetView setFrame:CGRectMake(0, H - height, W, height)];
    }];

}

-(void)clickedButtons:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger buttonIndex = btn.tag - 100;
    typeof(self) __weak weak = self;
    CGFloat height = ((ItemHeight+0.5f)+Spacing) + (_otherButtonTitles.count * (ItemHeight+0.5f))+ kSubTitleHeight;
    
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        [_sheetView setFrame:CGRectMake(0, H, W, height)];
        
    } completion:^(BOOL finished) {
        
        weak.clickedButtonAtIndex(buttonIndex);
        [self removeFromSuperview];
        
    }];
    
}

-(void)tapDismiss:(UITapGestureRecognizer *)tap{
    
    if( CGRectContainsPoint(self.frame, [tap locationInView:_sheetView])) {
        NSLog(@"tap");
    } else{
        typeof(self) __weak weak = self;
        CGFloat height = ((ItemHeight+0.5f)+Spacing) + (_otherButtonTitles.count * (ItemHeight+0.5f))+ kSubTitleHeight;
        
        [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
            [_sheetView setFrame:CGRectMake(0, H, W, height)];
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            
        }];
    }
}



@end
