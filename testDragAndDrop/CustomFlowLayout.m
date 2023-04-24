//
//  CustomFlowLayout.m
//  testDragAndDrop
//
//  Created by 云中追月 on 2023/4/12.
//

#import "CustomFlowLayout.h"
// 自定义UICollectionViewFlowLayout子类
@interface CustomFlowLayout()


@end

@implementation CustomFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray<UICollectionViewLayoutAttributes *> *modifiedAttributes = [NSMutableArray array];
    CGFloat minY = CGFLOAT_MAX;
    CGFloat sectionHeight = 0.0;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
            minY = MIN(minY, CGRectGetMinY(attribute.frame));
            sectionHeight = MAX(sectionHeight, CGRectGetMaxY(attribute.frame));
        } else if (attribute.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            minY = MIN(minY, CGRectGetMinY(attribute.frame));
            sectionHeight = MAX(sectionHeight, CGRectGetMaxY(attribute.frame));
        } else if (attribute.representedElementCategory == UICollectionElementCategoryDecorationView) {
            minY = MIN(minY, CGRectGetMinY(attribute.frame));
            sectionHeight = MAX(sectionHeight, CGRectGetMaxY(attribute.frame));
        }
    }
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.representedElementKind == UICollectionElementKindSectionHeader) {
            attribute.frame = CGRectMake(attribute.frame.origin.x, minY, attribute.frame.size.width, attribute.frame.size.height);
            [modifiedAttributes addObject:attribute];
        } else if (attribute.representedElementKind == UICollectionElementKindSectionFooter) {
            attribute.frame = CGRectMake(attribute.frame.origin.x, sectionHeight, attribute.frame.size.width, attribute.frame.size.height);
            [modifiedAttributes addObject:attribute];
        } else if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
            attribute.frame = CGRectMake(attribute.frame.origin.x, CGRectGetMaxY(attribute.frame), attribute.frame.size.width, attribute.frame.size.height);
            [modifiedAttributes addObject:attribute];
        } else {
            [modifiedAttributes addObject:attribute];
        }
    }
    return modifiedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGFloat minY = CGRectGetMinY(attributes.frame);
        attributes.frame = CGRectMake(attributes.frame.origin.x, minY, attributes.frame.size.width, attributes.frame.size.height);
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        CGFloat sectionHeight = CGRectGetMaxY(attributes.frame);
        attributes.frame = CGRectMake(attributes.frame.origin.x, sectionHeight, attributes.frame.size.width, attributes.frame.size.height);
    }
    return attributes;
}

- (CGSize)collectionViewContentSize {
    CGSize contentSize = [super collectionViewContentSize];
    contentSize.height = MAX(contentSize.height, self.minimumSectionHeight);
    return contentSize;
}

@end
