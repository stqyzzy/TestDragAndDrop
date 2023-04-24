//
//  NormalCollectionViewCell.m
//  testDragAndDrop
//
//  Created by 云中追月 on 2023/4/12.
//

#import "NormalCollectionViewCell.h"

@interface NormalCollectionViewCell()
@end

@implementation NormalCollectionViewCell

#pragma mark -
#pragma mark - life cycle - 生命周期
- (void)dealloc{
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.label.text = @"";
    self.backgroundColor = [UIColor whiteColor];
}
#pragma mark -
#pragma mark - init setup - 初始化视图
- (void)setup{
    [self setDefault];//初始化默认数据
    [self setupSubViews];//设置子View
    [self setupSubViewsConstraints];//设置子View约束
}

/// 设置默认数据
- (void)setDefault{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self addSubview:self.label];
}

/// 设置子视图
- (void)setupSubViews{
    
}

/// 设置子视图约束
-(void)setupSubViewsConstraints{
    
}

#pragma mark -
#pragma mark - public methods


#pragma mark -
#pragma mark - <#custom#> Delegate

#pragma mark -
#pragma mark - event response

#pragma mark -
#pragma mark - private methods

#pragma mark -
#pragma mark - getters and setters
- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.contentMode = UIViewContentModeScaleAspectFill;
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.frame = self.bounds;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.layer.borderWidth = 1;
        _label.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _label;
}
@end
