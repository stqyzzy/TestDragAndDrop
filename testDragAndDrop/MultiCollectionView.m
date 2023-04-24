//
//  MultiCollectionView.m
//  testDragAndDrop
//
//  Created by 云中追月 on 2023/4/11.
//

#import "MultiCollectionView.h"
#import "DragDropCollectionViewCell.h"

@interface MultiCollectionView()<UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate>
@property (nonatomic, strong) NSMutableArray *item1MutableArray;
@property (nonatomic, strong) NSMutableArray *item2MutableArray;
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionView *collectionView2;

@end

@implementation MultiCollectionView

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

#pragma mark -
#pragma mark - init setup - 初始化视图
- (void)setup{
    [self setDefault];//初始化默认数据
    [self setupSubViews];//设置子View
    [self setupSubViewsConstraints];//设置子View约束
}

/// 设置默认数据
- (void)setDefault{
    
}

/// 设置子视图
- (void)setupSubViews{
    [self addSubview:self.collectionView1];
    [self addSubview:self.collectionView2];
}

/// 设置子视图约束
-(void)setupSubViewsConstraints{
    
}

#pragma mark -
#pragma mark - public methods

#pragma mark -
#pragma mark - UICollectionViewDataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView == self.collectionView1 ? self.item1MutableArray.count : self.item2MutableArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView1) {
        DragDropCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
        cell.customImageView.image = [UIImage imageNamed:self.item1MutableArray[indexPath.row]];
        cell.customLabel.text = self.item1MutableArray[indexPath.row];
        return cell;
    } else {
        DragDropCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
        cell.customImageView.image = [UIImage imageNamed:self.item2MutableArray[indexPath.row]];
        cell.customLabel.text = self.item2MutableArray[indexPath.row];
        return cell;
    }
}
#pragma mark - UICollectionViewDragDelegate Delegate
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    NSString *itemString = collectionView == self.collectionView1 ? self.item1MutableArray[indexPath.row] : self.item2MutableArray[indexPath.row];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:itemString];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = itemString;
    return @[dragItem];
}

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    NSString *itemString = collectionView == self.collectionView1 ? self.item1MutableArray[indexPath.row] : self.item2MutableArray[indexPath.row];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:itemString];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = itemString;
    return @[dragItem];
}

- (UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView1) {
        UIDragPreviewParameters *previewParameters = [[UIDragPreviewParameters alloc] init];
        previewParameters.visiblePath = [UIBezierPath bezierPathWithRect:CGRectMake(25, 25, 120, 120)];
        return previewParameters;
    }
    return nil;
}
#pragma mark - UICollectionViewDropDelegate Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[NSString class]];
}

- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    if (collectionView == self.collectionView1) {
        if ([collectionView hasActiveDrag]) {
            // collectionView1拖拽的
            return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
        } else {
            return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationForbidden];
        }
    } else {
        if ([collectionView hasActiveDrag]) {
            // collectionView2拖拽的
            return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
        } else {
            return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    NSIndexPath *destinationIndexPath;
    if (coordinator.destinationIndexPath) {
        destinationIndexPath = coordinator.destinationIndexPath;
    } else {
        NSInteger section = collectionView.numberOfSections - 1;
        NSInteger row = [collectionView numberOfItemsInSection:section];
        destinationIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }
    switch (coordinator.proposal.operation) {
        case UIDropOperationMove:
            [self reorderItemsWithCoordinator:coordinator destinationIndexPath:destinationIndexPath collectionView:collectionView];
            break;
        case UIDropOperationCopy:
            [self copyItemsWithCoordinator:coordinator destinationIndexPath:destinationIndexPath collectionView:collectionView];
            break;

        default:
            return;;
    }
}
#pragma mark -
#pragma mark - event response

#pragma mark -
#pragma mark - private methods
- (void)reorderItemsWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator destinationIndexPath:(NSIndexPath *)destinationIndexPath collectionView:(UICollectionView *)collectionView {
    NSArray<id<UICollectionViewDropItem>> *itemsArray = coordinator.items;
    if (itemsArray.count == 1) {
        NSIndexPath *sourceIndexPath = itemsArray.firstObject.sourceIndexPath;
        NSIndexPath *dIndexPath = destinationIndexPath;
        if (dIndexPath.row >= [collectionView numberOfItemsInSection:0]) {
            destinationIndexPath = [NSIndexPath indexPathForRow:[collectionView numberOfItemsInSection:0] - 1 inSection:destinationIndexPath.section];
        }
        
        [collectionView performBatchUpdates:^{
            if (collectionView == self.collectionView2) {
                [self.item2MutableArray removeObjectAtIndex:sourceIndexPath.row];
                [self.item2MutableArray insertObject:itemsArray.firstObject.dragItem atIndex:dIndexPath.row];
            } else {
                [self.item1MutableArray removeObjectAtIndex:sourceIndexPath.row];
                [self.item1MutableArray insertObject:itemsArray.firstObject.dragItem.localObject atIndex:dIndexPath.row];
            }
        } completion:nil];
        [coordinator dropItem:itemsArray.firstObject.dragItem toItemAtIndexPath:dIndexPath];
    }
}

- (void)copyItemsWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator destinationIndexPath:(NSIndexPath *)destinationIndexPath collectionView:(UICollectionView *)collectionView {
    [collectionView performBatchUpdates:^{
        NSMutableArray *indexPathMutableArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < coordinator.items.count; i++) {
            id<UICollectionViewDropItem> item = coordinator.items[i];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:destinationIndexPath.row + i inSection:destinationIndexPath.section];
            if (collectionView == self.collectionView2) {
                [self.item2MutableArray insertObject:item.dragItem.localObject atIndex:indexPath.row];
            } else {
                [self.item1MutableArray insertObject:item.dragItem.localObject atIndex:indexPath.row];
            }
            [indexPathMutableArray addObject:indexPath];
        }
        [collectionView insertItemsAtIndexPaths:[indexPathMutableArray copy]];
    } completion:nil];
}
#pragma mark -
#pragma mark - getters and setters
- (NSMutableArray *)item1MutableArray {
    if (_item1MutableArray == nil) {
        _item1MutableArray = [[NSMutableArray alloc] initWithObjects:@"none", @"chrome", @"fade", @"falseColor", @"instant", @"mono", @"noir", @"process", @"sepia", @"tonal", @"transfer", nil];
    }
    return _item1MutableArray;
}

- (NSMutableArray *)item2MutableArray {
    if (_item2MutableArray == nil) {
        _item2MutableArray = [[NSMutableArray alloc] init];
    }
    return _item2MutableArray;
}

- (UICollectionView *)collectionView1 {
    if (_collectionView1 == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) collectionViewLayout:layout];
        _collectionView1.dragInteractionEnabled = YES;
        _collectionView1.dragDelegate = self;
        _collectionView1.dropDelegate = self;
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        [_collectionView1 registerClass:[DragDropCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
        _collectionView1.backgroundColor = [UIColor redColor];
    }
    return _collectionView1;
}

- (UICollectionView *)collectionView2 {
    if (_collectionView2 == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 300) collectionViewLayout:layout];
        _collectionView2.dragInteractionEnabled = YES;
        _collectionView2.dragDelegate = self;
        _collectionView2.dropDelegate = self;
        _collectionView2.delegate = self;
        _collectionView2.dataSource = self;
        _collectionView2.springLoaded = YES;
        _collectionView2.reorderingCadence = UICollectionViewReorderingCadenceImmediate;
        [_collectionView2 registerClass:[DragDropCollectionViewCell class] forCellWithReuseIdentifier:@"cell2"];
        _collectionView2.backgroundColor = [UIColor yellowColor];
    }
    return _collectionView2;
}

@end
