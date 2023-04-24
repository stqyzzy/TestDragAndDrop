//
//  DragDropCollectionViewCell.m
//  testDragAndDrop
//
//  Created by 云中追月 on 2023/4/11.
//

#import "DragDropCollectionViewCell.h"

@interface DragDropCollectionViewCell()

@end

@implementation DragDropCollectionViewCell

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
- (void)layoutSubviews {
    self.customImageView.frame = self.bounds;
    self.customLabel.frame = CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30);
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
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
}

/// 设置子视图
- (void)setupSubViews{
    [self addSubview:self.customImageView];
    [self addSubview:self.customLabel];
}

/// 设置子视图约束
-(void)setupSubViewsConstraints{
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.customLabel.text = nil;
    self.backgroundColor = [UIColor whiteColor];
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
- (UILabel *)customLabel {
    if (_customLabel == nil) {
        _customLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _customLabel.contentMode = UIViewContentModeScaleAspectFill;
        _customLabel.translatesAutoresizingMaskIntoConstraints = false;
        _customLabel.textAlignment = NSTextAlignmentCenter;
        _customLabel.textColor = [UIColor whiteColor];
    }
    return _customLabel;
}

- (UIImageView *)customImageView {
    if (_customImageView == nil) {
        _customImageView = [[UIImageView alloc] init];
    }
    return _customImageView;
}
@end
