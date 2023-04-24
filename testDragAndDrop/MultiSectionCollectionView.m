//
//  MultiSectionCollectionView.m
//  testDragAndDrop
//
//  Created by 云中追月 on 2023/4/11.
//

#import "MultiSectionCollectionView.h"
#import "NormalCollectionViewCell.h"
#import "NormalSupplementaryView.h"
#import "CustomFlowLayout.h"
@interface CellModel:NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger type;
@end

@implementation CellModel

@end

@interface MultiSectionCollectionView()<UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate>
@property (nonatomic, copy) NSString *cellIdentifierString;
@property (nonatomic, copy) NSString *supplementaryViewIdentifierString;
@property (nonatomic, assign) NSInteger sections;
@property (nonatomic, assign) NSInteger itemsInSection;
@property (nonatomic, assign) NSInteger numberOfElementsInRow;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<CellModel *> *> *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MultiSectionCollectionView

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
    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
}

/// 设置子视图约束
-(void)setupSubViewsConstraints{
    
}

#pragma mark -
#pragma mark - public methods


#pragma mark -
#pragma mark - UICollectionViewDataSource Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *cellModel = self.dataArray[indexPath.section][indexPath.item];
    if (cellModel.type == 1) {
        NormalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifierString forIndexPath:indexPath];
        cell.label.text = cellModel.text;
        cell.backgroundColor = [UIColor grayColor];
        return cell;
    } else {
        NormalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifierString forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.3];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NormalSupplementaryView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.supplementaryViewIdentifierString forIndexPath:indexPath];
    return headerView;
}
#pragma mark - UICollectionViewDragDelegate Delegate
// 给定可以操作的Item
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    NSString *indexPathString = [NSString stringWithFormat:@"%ld,%ld", (long)indexPath.section, (long)indexPath.row]; // 将 NSIndexPath 转换为 NSString
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:indexPathString];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = self.dataArray[indexPath.section][indexPath.row];
    return @[dragItem];
}
// 该方法是muti-touch对应的方法
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    NSString *indexPathString = [NSString stringWithFormat:@"%ld,%ld", (long)indexPath.section, (long)indexPath.row]; // 将 NSIndexPath 转换为 NSString
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:indexPathString];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = self.dataArray[indexPath.section][indexPath.row];
    return @[dragItem];
}
/* 当 lift animation 完成之后开始拖拽之前会调用该方法
 * 该方法肯定会对应着 -collectionView:dragSessionDidEnd: 的调用
 */
- (void)collectionView:(UICollectionView *)collectionView dragSessionWillBegin:(id<UIDragSession>)session {
    NSMutableArray *itemsToInsert = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArray.count; i++) {
        [itemsToInsert addObject:[NSIndexPath indexPathForItem:self.dataArray[i].count inSection:i]];
        CellModel *cellModel = [[CellModel alloc] init];
        cellModel.type = 2;
        [self.dataArray[i] addObject:cellModel];
    }
    [collectionView insertItemsAtIndexPaths:itemsToInsert];
}

// 拖拽结束的时候会调用该方法
- (void)collectionView:(UICollectionView *)collectionView dragSessionDidEnd:(id<UIDragSession>)session {
    NSMutableArray *removeItems = [[NSMutableArray alloc] init];
    for (int section = 0; section < self.dataArray.count; section++) {
        for (int item = 0; item < self.dataArray[section].count; item++) {
            CellModel *cellModel = self.dataArray[section][item];
            if (cellModel.type == 2) {
                [removeItems addObject:[NSIndexPath indexPathForItem:item inSection:section]];
            }
        }
    }
    for (NSIndexPath *indexPath in removeItems) {
        [self.dataArray[indexPath.section] removeObjectAtIndex:indexPath.item];
    }
    [collectionView deleteItemsAtIndexPaths:removeItems];
}
#pragma mark - UICollectionViewDropDelegate Delegate
// 当用户开始进行drop操作的时候会调用这个方法
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
            break;
    }
}
// 通过该方法判断对应的item能否被执行
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    return YES;
}
// 该方法是提供释放方案的方法，当跟踪drop行为在tableView或collectionView空间坐标区域内部时会频繁调用，主要是动画效果
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    if (collectionView.hasActiveDrag && destinationIndexPath != nil) {
        CellModel *cellModel = self.dataArray[destinationIndexPath.section][destinationIndexPath.row];
        if (cellModel.type == 1) {
            return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
        } else {
            return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertIntoDestinationIndexPath];
        }
    } else {
        return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationForbidden];
    }
}
#pragma mark -
#pragma mark - event response

#pragma mark -
#pragma mark - private methods
- (void)reorderItemsWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator destinationIndexPath:(NSIndexPath *)destinationIndexPath collectionView:(UICollectionView *)collectionView {
    if (coordinator.items.count == 1) {
        NSIndexPath *sourceIndexPath = coordinator.items.firstObject.sourceIndexPath;
        id localObject = coordinator.items.firstObject.dragItem.localObject;
        if ([localObject isKindOfClass:[CellModel class]]) {
            [collectionView performBatchUpdates:^{
                [self.dataArray[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.item];
                [self.dataArray[destinationIndexPath.section] insertObject:localObject atIndex:destinationIndexPath.item];
                [collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
                [collectionView insertItemsAtIndexPaths:@[destinationIndexPath]];
            } completion:nil];
        }
    }
}

- (void)copyItemsWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator
            destinationIndexPath:(NSIndexPath *)destinationIndexPath
                  collectionView:(UICollectionView *)collectionView {
    [collectionView performBatchUpdates:^{
        NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
        for (NSInteger index = 0; index < coordinator.items.count; index++) {
            id localObject = coordinator.items[index].dragItem.localObject;
            if ([localObject isKindOfClass:[CellModel class]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:destinationIndexPath.row + index inSection:destinationIndexPath.section];
                [self.dataArray[indexPath.section] insertObject:localObject atIndex:indexPath.row];
                [indexPaths addObject:indexPath];
            }
        }
        [collectionView insertItemsAtIndexPaths:indexPaths];
    } completion:nil];
}

#pragma mark -
#pragma mark - getters and setters
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewFlowLayout.minimumLineSpacing = 5;
        collectionViewFlowLayout.minimumInteritemSpacing = 5;
        CGFloat allWidthBetwenCells = self.numberOfElementsInRow == 0 ? 0 : collectionViewFlowLayout.minimumInteritemSpacing * (self.numberOfElementsInRow - 1);
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - allWidthBetwenCells) / self.numberOfElementsInRow;
        collectionViewFlowLayout.itemSize = CGSizeMake(width, width);
        collectionViewFlowLayout.headerReferenceSize = CGSizeMake(0, 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:collectionViewFlowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[NormalCollectionViewCell class] forCellWithReuseIdentifier:self.cellIdentifierString];
        [_collectionView registerClass:[NormalSupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.supplementaryViewIdentifierString];
        
        _collectionView.dragInteractionEnabled = YES;
        _collectionView.reorderingCadence = UICollectionViewReorderingCadenceFast;
        _collectionView.dropDelegate = self;
        _collectionView.dragDelegate = self;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSInteger)numberOfElementsInRow {
    return 3;
}

- (NSInteger)sections {
    return 10;
}

- (NSInteger)itemsInSection {
    return 2;
}

- (NSString *)cellIdentifierString {
    if (_cellIdentifierString == nil) {
        _cellIdentifierString = @"cellIdentifier";
    }
    return _cellIdentifierString;
}

- (NSString *)supplementaryViewIdentifierString {
    if (_supplementaryViewIdentifierString == nil) {
        _supplementaryViewIdentifierString = @"supplementaryViewIdentifier";
    }
    return _supplementaryViewIdentifierString;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
        NSInteger count = 0;
        for (int i = 0; i < self.sections; i++) {
            NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init];
            for (int j = 0; j < self.itemsInSection; j++) {
                count++;
                CellModel *cellModel = [[CellModel alloc] init];
                cellModel.type = 1;
                cellModel.text = [NSString stringWithFormat:@"cell %d", count];
                [tempMutableArray addObject:cellModel];
            }
            [_dataArray addObject:tempMutableArray];
        }
    }
    return _dataArray;
}
@end
