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

#import "LMRowView.h"
#import "LMColumnView.h"
#import "NSObject+Markup.h"
#import "UIView+Markup.h"

static NSDictionary *baselineValues;

@implementation LMRowView

+ (void)initialize
{
    baselineValues = @{
        @"first": @(LMBaselineFirst),
        @"last": @(LMBaselineLast)
    };
}

- (void)setAlignToBaseline:(BOOL)alignToBaseline
{
    _alignToBaseline = alignToBaseline;

    [self setNeedsUpdateConstraints];
}

- (void)setBaseline:(LMBaseline)baseline
{
    _baseline = baseline;

    [self setNeedsUpdateConstraints];
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"baseline"]) {
        value = [baselineValues objectForKey:value];
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

- (void)layoutSubviews
{
    // Don't give subviews a higher vertical content compression resistance priority than this view's
    UILayoutPriority verticalContentCompressionResistancePriority = MIN(UILayoutPriorityRequired,
        [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical]);

    // Ensure that subviews resize according to weight
    UIView *superview = [self superview];

    UILayoutPriority unweightedHorizontalContentHuggingPriority;
    if ([superview isKindOfClass:[LMColumnView self]] && [(LMColumnView *)superview alignToGrid]) {
        unweightedHorizontalContentHuggingPriority = UILayoutPriorityDefaultHigh;
    } else {
        unweightedHorizontalContentHuggingPriority = UILayoutPriorityRequired;
    }

    for (UIView * subview in _arrangedSubviews) {
        [subview setContentCompressionResistancePriority:verticalContentCompressionResistancePriority forAxis:UILayoutConstraintAxisVertical];
        [subview setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];

        UILayoutPriority horizontalContentCompressionResistancePriority, horizontalContentHuggingPriority;
        if (isnan([subview weight])) {
            horizontalContentCompressionResistancePriority = UILayoutPriorityRequired;
            horizontalContentHuggingPriority = unweightedHorizontalContentHuggingPriority;
        } else {
            horizontalContentCompressionResistancePriority = UILayoutPriorityDefaultLow;
            horizontalContentHuggingPriority = UILayoutPriorityDefaultLow;
        }

        [subview setContentCompressionResistancePriority:horizontalContentCompressionResistancePriority forAxis:UILayoutConstraintAxisHorizontal];
        [subview setContentHuggingPriority:horizontalContentHuggingPriority forAxis:UILayoutConstraintAxisHorizontal];
    }

    [super layoutSubviews];
}

- (NSArray *)createConstraints
{
    NSMutableArray *constraints = [NSMutableArray new];

    CGFloat spacing = [self spacing];

    NSLayoutAttribute topAttribute, bottomAttribute, leadingAttribute, trailingAttribute;
    if ([self layoutMarginsRelativeArrangement]) {
        topAttribute = NSLayoutAttributeTopMargin;
        bottomAttribute = NSLayoutAttributeBottomMargin;
        leadingAttribute = NSLayoutAttributeLeadingMargin;
        trailingAttribute = NSLayoutAttributeTrailingMargin;
    } else {
        topAttribute = NSLayoutAttributeTop;
        bottomAttribute = NSLayoutAttributeBottom;
        leadingAttribute = NSLayoutAttributeLeading;
        trailingAttribute = NSLayoutAttributeTrailing;
    }

    UIView *previousSubview = nil;
    UIView *previousWeightedSubview = nil;

    for (UIView *subview in _arrangedSubviews) {
        if ([subview isHidden]) {
            continue;
        }

        // Align to siblings
        if (previousSubview == nil) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading
                relatedBy:NSLayoutRelationEqual toItem:self attribute:leadingAttribute
                multiplier:1 constant:0]];
        } else {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading
                relatedBy:NSLayoutRelationEqual toItem:previousSubview attribute:NSLayoutAttributeTrailing
                multiplier:1 constant:spacing]];

            if (_alignToBaseline) {
                NSLayoutAttribute baselineAttribute;
                switch (_baseline) {
                    case LMBaselineFirst: {
                        baselineAttribute = NSLayoutAttributeFirstBaseline;
                        break;
                    }

                    case LMBaselineLast: {
                        baselineAttribute = NSLayoutAttributeLastBaseline;
                        break;
                    }
                }

                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:baselineAttribute
                    relatedBy:NSLayoutRelationEqual toItem:previousSubview attribute:baselineAttribute
                    multiplier:1 constant:0]];
            }
        }

        CGFloat weight = [subview weight];

        if (!isnan(weight) && isnan([subview width])) {
            if (previousWeightedSubview != nil) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth
                    relatedBy:NSLayoutRelationEqual toItem:previousWeightedSubview attribute:NSLayoutAttributeWidth
                    multiplier:weight / [previousWeightedSubview weight] constant:0]];
            }

            previousWeightedSubview = subview;
        }

        // Align to parent
        if (_alignToBaseline) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop
                relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:topAttribute
                multiplier:1 constant:0]];

            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom
                relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:bottomAttribute
                multiplier:1 constant:0]];
        } else {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop
                relatedBy:NSLayoutRelationEqual toItem:self attribute:topAttribute
                multiplier:1 constant:0]];

            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom
                relatedBy:NSLayoutRelationEqual toItem:self attribute:bottomAttribute
                multiplier:1 constant:0]];
        }

        previousSubview = subview;
    }

    // Align final view to trailing edge
    if (previousSubview != nil) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:previousSubview attribute:NSLayoutAttributeTrailing
            relatedBy:NSLayoutRelationEqual toItem:self attribute:trailingAttribute
            multiplier:1 constant:0]];
    }

    return constraints;
}

@end
