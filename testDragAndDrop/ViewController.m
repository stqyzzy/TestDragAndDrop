//
//  ViewController.m
//  testDragAndDrop
//
//  Created by 云中追月 on 2023/4/7.
//

#import "ViewController.h"
#import "MultiCollectionView.h"
#import "MultiSectionCollectionView.h"
@interface ViewController ()
@end

@implementation ViewController

#pragma mark -
#pragma mark - life cycle - 生命周期
- (void)dealloc{
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];//初始化
}

#pragma mark -
#pragma mark - init setup - 初始化视图
- (void)setup{
    [self setDefault];//初始化默认数据
    [self setupSubViews];//设置子View
    [self bindViewModel];//绑定vm
    [self loadData];//加载网络数据
}

/// 设置默认数据
- (void)setDefault{

}

/// 设置子视图
- (void)setupSubViews{
//    MultiCollectionView *view = [[MultiCollectionView alloc] init];
    MultiSectionCollectionView *view = [[MultiSectionCollectionView alloc] init];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
}

///绑定viewModel
- (void)bindViewModel{
    
}

/// 加载数据
- (void)loadData{
    
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

@end
