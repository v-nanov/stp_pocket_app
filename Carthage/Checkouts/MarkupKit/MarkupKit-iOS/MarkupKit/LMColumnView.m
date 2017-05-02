//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "LMColumnView.h"
#import "LMRowView.h"
#import "UIView+Markup.h"

@implementation LMColumnView

- (void)setAlignToGrid:(BOOL)alignToGrid
{
    _alignToGrid = alignToGrid;

    [self setNeedsUpdateConstraints];
}

- (void)setTopSpacing:(CGFloat)topSpacing
{
    _topSpacing = topSpacing;

    [self setNeedsUpdateConstraints];
}

- (void)setBottomSpacing:(CGFloat)bottomSpacing
{
    _bottomSpacing = bottomSpacing;

    [self setNeedsUpdateConstraints];
}

- (void)layoutSubviews
{
    // Don't give subviews a higher horizontal content compression resistance priority than this view's
    UILayoutPriority horizontalContentCompressionResistancePriority = MIN(UILayoutPriorityRequired,
        [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal]);

    // Ensure that subviews resize according to weight
    for (UIView * subview in _arrangedSubviews) {
        [subview setContentCompressionResistancePriority:horizontalContentCompressionResistancePriority forAxis:UILayoutConstraintAxisHorizontal];
        [subview setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

        UILayoutPriority verticalPriority = isnan([subview weight]) ? UILayoutPriorityRequired : UILayoutPriorityDefaultLow;

        [subview setContentCompressionResistancePriority:verticalPriority forAxis:UILayoutConstraintAxisVertical];
        [subview setContentHuggingPriority:verticalPriority forAxis:UILayoutConstraintAxisVertical];
    }

    [super layoutSubviews];
}

- (NSArray *)createConstraints
{
    NSMutableArray *constraints = [NSMutableArray new];

    CGFloat spacing = [self spacing];

    NSLayoutAttribute topAttribute, bottomAttribute, leftAttribute, rightAttribute;
    if ([self layoutMarginsRelativeArrangement]) {
        topAttribute = NSLayoutAttributeTopMargin;
        bottomAttribute = NSLayoutAttributeBottomMargin;
        leftAttribute = NSLayoutAttributeLeftMargin;
        rightAttribute = NSLayoutAttributeRightMargin;
    } else {
        topAttribute = NSLayoutAttributeTop;
        bottomAttribute = NSLayoutAttributeBottom;
        leftAttribute = NSLayoutAttributeLeft;
        rightAttribute = NSLayoutAttributeRight;
    }

    UIView *previousSubview = nil;
    UIView *previousWeightedSubview = nil;

    for (UIView *subview in _arrangedSubviews) {
        if ([subview isHidden]) {
            continue;
        }

        // Align to siblings
        if (previousSubview == nil) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop
                relatedBy:NSLayoutRelationEqual toItem:self attribute:topAttribute
                multiplier:1 constant:_topSpacing]];
        } else {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop
                relatedBy:NSLayoutRelationEqual toItem:previousSubview attribute:NSLayoutAttributeBottom
                multiplier:1 constant:spacing]];
        }

        CGFloat weight = [subview weight];

        if (!isnan(weight) && isnan([subview height])) {
            if (previousWeightedSubview != nil) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeHeight
                    relatedBy:NSLayoutRelationEqual toItem:previousWeightedSubview attribute:NSLayoutAttributeHeight
                    multiplier:weight / [previousWeightedSubview weight] constant:0]];
            }

            previousWeightedSubview = subview;
        }

        // Align to parent
        [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft
            relatedBy:NSLayoutRelationEqual toItem:self attribute:leftAttribute
            multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeRight
            relatedBy:NSLayoutRelationEqual toItem:self attribute:rightAttribute
            multiplier:1 constant:0]];

        // Align subviews
        if (_alignToGrid && [subview isKindOfClass:[LMRowView self]] && [previousSubview isKindOfClass:[LMRowView self]]) {
            NSArray *nestedSubviews = ((LMLayoutView *)subview)->_arrangedSubviews;
            NSArray *previousNestedSubviews = ((LMLayoutView *)previousSubview)->_arrangedSubviews;

            for (NSUInteger i = 0, n = MIN([nestedSubviews count], [previousNestedSubviews count]); i < n; i++) {
                UIView *nestedSubview = [nestedSubviews objectAtIndex:i];
                UIView *previousNestedSubview = [previousNestedSubviews objectAtIndex:i];

                [constraints addObject:[NSLayoutConstraint constraintWithItem:nestedSubview attribute:NSLayoutAttributeWidth
                    relatedBy:NSLayoutRelationEqual toItem:previousNestedSubview attribute:NSLayoutAttributeWidth
                    multiplier:1 constant:0]];
            }
        }

        previousSubview = subview;
    }

    // Align final view to bottom edge
    if (previousSubview != nil) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:previousSubview attribute:NSLayoutAttributeBottom
            relatedBy:NSLayoutRelationEqual toItem:self attribute:bottomAttribute
            multiplier:1 constant:-_bottomSpacing]];
    }

    return constraints;
}

@end
