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

#import "UIControl+Markup.h"
#import "NSObject+Markup.h"

static NSDictionary *controlContentHorizontalAlignmentValues;
static NSDictionary *controlContentVerticalAlignmentValues;

@implementation UIControl (Markup)

+ (void)initialize
{
    controlContentHorizontalAlignmentValues = @{
        @"center": @(UIControlContentHorizontalAlignmentCenter),
        @"left": @(UIControlContentHorizontalAlignmentLeft),
        @"right": @(UIControlContentHorizontalAlignmentRight),
        @"fill": @(UIControlContentHorizontalAlignmentFill)
    };

    controlContentVerticalAlignmentValues = @{
        @"center": @(UIControlContentVerticalAlignmentCenter),
        @"top": @(UIControlContentVerticalAlignmentTop),
        @"bottom": @(UIControlContentVerticalAlignmentBottom),
        @"fill": @(UIControlContentVerticalAlignmentFill)
    };
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"contentHorizontalAlignment"]) {
        value = [controlContentHorizontalAlignmentValues objectForKey:value];
    } else if ([key isEqual:@"contentVerticalAlignment"]) {
        value = [controlContentVerticalAlignmentValues objectForKey:value];
    }
    
    [super applyMarkupPropertyValue:value forKey:key];
}

@end
